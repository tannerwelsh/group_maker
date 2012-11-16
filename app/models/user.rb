class User < ActiveRecord::Base
  attr_accessible :email, :name

  belongs_to :project_member
  has_one :project, through: :project_member

  has_many :project_choices
end
