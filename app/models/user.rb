class User < ActiveRecord::Base
  attr_accessible :email, :name

  belongs_to :project
  has_many :choices, class_name: 'ProjectChoice'
  has_many :created_projects, class_name: 'Project', foreign_key: :creator_id

  scope :has_project, where('project_id IS NOT NULL')
  scope :needs_project, where(project_id: nil)
  scope :alphabetical, order(:name)

  def needs_project?
    project.nil?
  end

  def has_project?
    !needs_project?
  end

  def is_creator?
    created_projects.count > 0
  end

  def join_project(project)
    tap { |u| u.project = project }.save!
  end

  def leave_project!
    tap { |u| u.project = nil }.save!
  end

  def choice(n)
    choices.detect { |choice| choice.priority == n }
  end

  def chosen?(n)
    choice(n) && choice(n).project == self.project
  end

end
