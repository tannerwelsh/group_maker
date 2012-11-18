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

  def high_interest?
    @choices.select(&:first_choice?).count >= 4
  end

  def next_member
    return nil if @choices.empty?
    @choices.sort_by!(&:priority)
    top_choice = @choices.shift
    return top_choice.user
  end

  def purge_selected_users!
    @choices.delete_if(&:user_selected?)
  end

  def nullify_project!
    puts "Not enough interest in #{project.name}"
    project.purge_members!
  end

  def to_s
    @project.name + ': ' + @choices.map { |c| "#{c.user.name} (#{c.priority})" }.join(', ')
  end
end