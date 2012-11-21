class Settings
  CONFIG_OPTIONS = [:voting, :choices]

  def self.config
    Hash[CONFIG_OPTIONS.map do |option|
      [option.to_s, self.send(option)]
    end]
  end

  def self.method_missing(option, *args)
    GroupMaker::Application.config.send("permit_#{option}", *args)
  end

  def self.set!(option, value)
    self.send("#{option}=", value)
  end

  def self.toggle!(option)
    self.set!(option, !Settings.send(option))
  end

  def self.num_projects
    (User.count / GroupList::GROUP_SIZE) + 2
  end
end