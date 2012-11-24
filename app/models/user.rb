class User < ActiveRecord::Base
  ROLES = %w[ admin student ]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to  :project
  has_many    :choices,           class_name: 'ProjectChoice'
  has_many    :created_projects,  class_name: 'Project', foreign_key: :creator_id

  acts_as_voter

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me, :choices_attributes

  accepts_nested_attributes_for :choices

  validates :name, presence: true

  scope :students,      where(role: 'student')
  scope :has_project,   students.where('project_id IS NOT NULL')
  scope :needs_project, students.where('project_id IS NULL')
  scope :alphabetized,  order(:name)


  def is?(role)
    self.role == role.to_s
  end


  def needs_project?
    project.nil?
  end

  def has_project?
    !needs_project?
  end

  def is_creator?
    !created_projects.empty?
  end

  def is_member?(proj)
    self.project == proj
  end

  def join_project(project)
    tap { |user| user.project = project }.save!
  end

  def leave_project!
    tap { |user| user.project = nil }.save!
  end


  def has_choices?
    choices.any?
  end

  def choice(priority)
    choices.detect { |choice| choice.priority == priority }
  end

  def chosen?(priority)
    choice(priority) && choice(priority).project == self.project
  end

  def load_choices
    ProjectChoice::PRIORITIES.map do |priority|
      choice(priority) || choices.build(priority: priority)
    end
  end

  def to_s
    name
  end

end
