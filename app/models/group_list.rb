class GroupList
  GROUP_SIZE_LIMIT = 4

  def self.build_projects!
    new.build_projects!
  end

  def initialize
    @priority_options = ProjectChoice::PRIORITIES
    @priority_stack   = Hash[@priority_options.map { |n| [n, []] }]
  end

  def build_projects!
    raw_groups.each do |group|
      group.purge_selected_users!
      project_from_group(group)
      
      prioritize_unpicked_users(group)
      clean_stack
    end
  end

private

  def project_from_group(group)
    users = select_users(group)

    if users.any?(&:nil?)
      group.nullify_project!
    else
      users.each { |user| user.join_project(group.project) }
    end
  end

  def select_users(group)
    group.size.upto(GROUP_SIZE_LIMIT).map do
      user_from_group(group)        
    end
  end

  def user_from_group(group)      
    @priority_options.each do |priority|
      next unless group.users.any? { |user| in_stack?(user, priority) }
      return select_from_stack(group.users, priority)
    end

    group.next_member
  end

  def select_from_stack(users, priority)
    (users & @priority_stack[priority]).sample
  end

  def in_stack?(user, priority)
    @priority_stack[priority].include? user
  end

  def raw_groups
    # TODO: Change this scope to 'top_choices'
    Project.all.map do |project|
      Group.new(project, project.choices)
    end
  end

  def prioritize_unpicked_users(group)
    group.choices.each do |choice|
      next if choice.user.has_project?
      @priority_stack[choice.priority] << choice.user 
    end
  end

  def clean_stack
    @priority_stack.each_pair do |priority, users|
      @priority_stack[priority] = users.select(&:needs_project?)
    end
  end

end
