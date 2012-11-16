class User < ActiveRecord::Base
  attr_accessible :email, :name

  belongs_to :project
  has_many :project_choices

  scope :has_group, where('project_id IS NOT NULL')
  scope :not_grouped, where(project_id: nil)

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
end
