class ProjectMember < ActiveRecord::Base
  attr_accessible :project_id, :type, :user_id

  belongs_to :project, :user
end
