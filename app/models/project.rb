require 'group_maker'

class Project < ActiveRecord::Base
  attr_accessible :name

  has_many :members, class_name: 'User'
  has_many :choices, class_name: 'ProjectChoice'

  def group_size
    members.count
  end

  def member_names
    members.map(&:name)
  end

  def purge_members!
    members.each(&:leave_project!)
  end

  def self.make_groups!
    GroupMaker.generate!
  end
end
