class Settings
  def self.config
    GroupMaker::Application::CUSTOM_CONFIG
  end

  def self.method_missing(method)
    GroupMaker::Application::CUSTOM_CONFIG[method.to_s]
  end

  def self.set!(option, value)
    GroupMaker::Application::CUSTOM_CONFIG[option] = value
  end

  def self.toggle!(option)
    self.set!(option, !GroupMaker::Application::CUSTOM_CONFIG[option])
  end

  def self.num_projects
    (User.count / GroupList::GROUP_SIZE) + 2
  end
end