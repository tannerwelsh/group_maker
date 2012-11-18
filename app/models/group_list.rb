class GroupList
  GROUP_SIZE = (3..4)

  def self.generate!
    new.generate_groups!
  end

  def initialize
    @priority_options = ProjectChoice::PRIORITIES
    @priority_stack   = Hash[@priority_options.map { |n| [n, []] }]
  end

  def generate_groups!
    raw_groups.each do |group|
      group.purge_selected_users!

      project_from_group(group)
      
      prioritize_unpicked_users(group)
      puts "PRIORITY STACK COUNT BEFORE clean_stack: #{@priority_stack.values.flatten.count}"
      clean_stack
      puts "PRIORITY STACK COUNT AFTER clean_stack: #{@priority_stack.values.flatten.count}"
    end
  end

private

  def raw_groups
    Project.sorted_by_priority(1).map do |project|
      Group.new(project, project.choices)
    end
  end

  def project_from_group(group)
    users = select_users(group)

    puts "USERS: #{users.map(&:name)}"

    unless GROUP_SIZE.include?(users.count + group.size)
      group.nullify_project!
    else
      users.each { |user| user.join_project(group.project) }
    end
  end

  def select_users(group)
    (GROUP_SIZE.last - group.size).times.map do
      user_from_group(group)
    end
  end

  def user_from_group(group)      
    @priority_options.each do |priority|
      if group.users.any? { |user| in_stack?(user, priority) }
        return select_from_stack(group.users, priority)
      end
    end

    group.next_member
  end

  def select_from_stack(users, priority)
    (users & @priority_stack[priority]).sample
  end

  def in_stack?(user, priority)
    @priority_stack[priority].include? user
  end

  def add_to_stack(user, priority)
    @priority_stack[priority] << user 
  end

  def clean_stack
    @priority_stack.each_pair do |priority, users|
      @priority_stack[priority] = users.select(&:needs_project?)
    end
  end

  def prioritize_unpicked_users(group)
    group.choices.each do |choice|
      next if choice.user_selected?
      add_to_stack(choice.user, choice.priority)
    end
  end

end
