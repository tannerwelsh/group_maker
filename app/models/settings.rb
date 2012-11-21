class Settings
  def self.num_of_allowed_projects
    (User.count / GroupList::GROUP_SIZE) + 2
  end

  def self.permit_voting
    GroupMaker::Application.config.permit_voting_on_projects
  end

  def self.permit_voting=(bool)
    GroupMaker::Application.config.permit_voting_on_projects = bool
  end

  def self.permit_choices
    GroupMaker::Application.config.permit_project_choices
  end

  def self.permit_choices=(bool)
    GroupMaker::Application.config.permit_project_choices = bool
  end
end