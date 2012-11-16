class Project < ActiveRecord::Base
  attr_accessible :name

  has_many :members, class_name: 'User'
end
