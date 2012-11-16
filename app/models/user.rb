class User < ActiveRecord::Base
  attr_accessible :email, :name

  belongs_to :project
  has_many :choices, class_name: 'ProjectChoice'

  scope :has_project, where('project_id IS NOT NULL')
  scope :needs_project, where(project_id: nil)

  def needs_project?
    self.project_id.nil?
  end

  def has_project?
    !needs_project?
  end

  def join_project(project)
    self.update_attribute(:project_id, project.id)
  end

  def leave_project!
    self.update_attribute(:project_id, nil)
  end

  def choice(n)
    choices.detect { |choice| choice.priority == n }
  end

  def chosen?(n)
    choice(n) && choice(n).project == self.project
  end

end
