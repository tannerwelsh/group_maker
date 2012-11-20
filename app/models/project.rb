class Project < ActiveRecord::Base
  attr_accessible :name

  has_many :members,    class_name: 'User'
  has_many :choices,    class_name: 'ProjectChoice'
  belongs_to :creator,  class_name: 'User'

  def self.sorted_by_popularity
    all.sort_by(&:interest_level).reverse
  end

  def self.sorted_by_priority(priority = 1)
    all.sort_by{|proj| proj.interest_by_priority(priority)}.reverse
  end

  def interest_level
    # Numeral to gauge the overall interest in a project
    choices.inject(0) do |memo, choice| 
      memo += choice.weighted_interest
    end
  end

  def interest_by_priority(priority)
    choices.with_priority(priority).count
  end

  def group_size
    members.count
  end

  def member_names
    members.map(&:name)
  end

  def creator_name
    creator.name
  end

  def purge_members!
    members.each(&:leave_project!)
  end

end
