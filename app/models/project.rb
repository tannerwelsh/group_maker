class Project < ActiveRecord::Base
  attr_accessible :name, :creator_id

  has_many :members,    class_name: 'User'
  has_many :choices,    class_name: 'ProjectChoice'
  belongs_to :creator,  class_name: 'User'

  validates :name, uniqueness: true

  acts_as_votable

  def self.sorted_by_votes
    includes(:votes).sort_by(&:vote_count).reverse
  end

  def self.sorted_by_popularity
    includes(:choices).sort_by(&:interest_level).reverse
  end

  def self.sorted_by_priority(priority = 1)
    includes(:choices).sort_by{|proj| proj.interest_by_priority(priority)}.reverse
  end

  def interest_level
    # Numeral to gauge the overall interest in a project
    choices.inject(0) do |memo, choice| 
      memo += choice.weighted_interest
    end
  end

  def interest_by_priority(priority)
    choices.with_priority(priority).size
  end

  def probability_for_acceptance
    ((GroupList::GROUP_SIZE / interest_by_priority(1).to_f) * 100).round(2)
  end

  def vote_count
    votes.size
  end

  def choice_for(member)
    choices.includes(:user).detect { |choice| choice.user == member } || false
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
