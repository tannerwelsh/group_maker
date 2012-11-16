class ProjectChoice < ActiveRecord::Base
  attr_accessible :priority, :project_id, :user_id

  belongs_to :project
  belongs_to :user

  def first_choice?
    priority == 1
  end

  def second_choice?
    priority == 2
  end

  def third_choice?
    priority == 3
  end
end
