class Project < ActiveRecord::Base
  attr_accessible :name

  has_many :project_members
  has_many :users, through: :project_members
end
