module GroupMaker
  PRIORITIES = [1,2,3]
  GROUP_SIZE_LIMIT = 4

  def self.generate!
    List.new.build_projects!
  end

  class Group
    attr_reader :project, :choices

    def initialize(project, choices)
      @project = project
      @choices = choices.shuffle
    end

    def size
      @project.group_size
    end

    def users
      @choices.map(&:user)
    end

    def has_interest?(priority)
      @choices.any? { |c| c.priority == priority }
    end

    def high_interest?
      @choices.select(&:first_choice?).count >= 4
    end

    def next_member
      return nil if @choices.empty?
      user = @choices.sort{ |a,b| a.priority <=> b.priority }.shift.user
    end

    def purge_selected_users!
      @choices.reject! { |choice| choice.user.has_project? }
    end

    def nullify_project!
      puts "Not enough interest in #{project.name}"
      project.purge_members!
    end
  end


  class List
    def initialize      
      @choices  = ProjectChoice.all
      @projects = Project.includes(:members)
      @priority_stack = Hash[PRIORITIES.map { |n| [n, []] }]
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

      group.nullify_project! if users.any?(&:nil?)

      users.each { |user| user.join_project(group.project) }
    end

    def select_users(group)
      group.size.upto(GROUP_SIZE_LIMIT).map do
        user_from_group(group)        
      end
    end

    def user_from_group(group)      
      PRIORITIES.each do |priority|
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
      unfiltered_groups = []
      @choices.group_by(&:project).each_pair do |project, choices|
        unfiltered_groups << Group.new(project, choices)
      end
      unfiltered_groups
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

end
