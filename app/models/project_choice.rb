class ProjectChoice < ActiveRecord::Base
  PRIORITIES = [1,2,3]

  attr_accessible :priority, :project_id, :user_id

  belongs_to :project
  belongs_to :user

  scope :with_priority, lambda{|priority| where(priority: priority)}

  # FIXME: This is not working
  # validates :project_id,  uniqueness: { scope: :user_id } 
  # validates :priority,    uniqueness: { scope: :user_id }
  validates :priority,    inclusion:  { in: PRIORITIES }

  def weighted_interest
    # Numeral to give the priorities given greater weight
    (priority - (PRIORITIES.count + 1)).abs * 10
  end

  def user_selected?
    user.has_project?
  end

  def project_name
    project.name
  end

end
