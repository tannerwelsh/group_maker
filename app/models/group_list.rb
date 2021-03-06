class GroupList
  GROUP_SIZE = 4

  def initialize
    @priority_stack = Hash[ProjectChoice::PRIORITIES.map { |n| [n, []] }]
    @current_priority = 1
    @groups = raw_groups
  end

  def self.generate!
    users_without_a_project = User.needs_project.count

    ActiveRecord::Base.transaction do
      GroupList.destroy_all!

      GroupList.new.generate_groups!

      if User.needs_project.count >= users_without_a_project
        raise ActiveRecord::Rollback
      end
    end
  end

  def self.destroy_all!
    Project.all.each(&:purge_members!)
  end

  def generate_groups!
    @priority_stack.keys.each do |priority|
      @current_priority = priority

      @groups.each do |group|
        next if group.size >= GROUP_SIZE
        group.purge_selected_users!

        project_from_group(group)
        
        build_and_refresh_stack(group)
      end
    end

    nullify_small_groups

    return self
  end

private

  def raw_groups
    Project.sorted_by_priority(1).map do |project|
      next if project.group_size == GROUP_SIZE
      Group.new(project, project.choices)
    end.reject(&:nil?)
  end

  def project_from_group(group)
    select_users(group).each { |user| user.join_project(group.project) }
  end

  def select_users(group)
    (GROUP_SIZE).times.map do
      user_from_group(group)
    end.reject(&:nil?)
  end

  def user_from_group(group)
    if group.users.any? { |user| user == group.project_creator }
      user = group.project_creator
      pull_user(group, user)
      
      return user
    elsif group.users.any? { |user| stack_users.include? user }
      user = select_from_stack(group.users)
      pull_user(group, user)
      
      return user
    else
      return group.next_member
    end
  end

  def pull_user(group, user)
    remove_from_stack!(user)
    group.remove!(user)
  end

  def nullify_small_groups
    @groups.select { |group| group.size < GROUP_SIZE }.each(&:nullify_project!)
  end

  # -------- Priority Stack --------

  def stack_users
    @priority_stack[@current_priority]
  end

  def select_from_stack(users)
    (users & @priority_stack[@current_priority]).sample(1).first
  end

  def remove_from_stack!(user)
    @priority_stack.each_pair do |priority, users|
      @priority_stack[priority].delete_if { |stacked_user| stacked_user == user }
    end
  end

  def add_to_stack(user, priority)
    @priority_stack[priority] << user 
  end

  def build_and_refresh_stack(group)
    prioritize_unpicked_users(group)
    clean_stack
  end

  def clean_stack
    User.has_project.each do |user|
      remove_from_stack!(user)
    end
  end

  def prioritize_unpicked_users(group)
    group.choices.each do |choice|
      next if choice.user_selected?
      add_to_stack(choice.user, choice.priority)
    end
  end

end
