class User < ActiveRecord::Base
  attr_accessible :email, :name

  belongs_to :project
  has_many :project_choices

  def join_project(project)
    self.update_attribute(:project_id, project.id)
  end
end
