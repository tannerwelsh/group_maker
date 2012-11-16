class ProjectChoice < ActiveRecord::Base
  attr_accessible :priority, :project_id, :user_id

  belongs_to :project
  belongs_to :user
end
