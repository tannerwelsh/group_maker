class Settings
  CONFIG = { 
    'voting'  => true, 
    'choices' => true
  }

  def self.method_missing(method)
    CONFIG[method.to_s]
  end

  def self.set!(option, value)
    CONFIG[option] = value
  end

  def self.toggle!(option)
    self.set!(option, !CONFIG[option])
  end

  def self.num_projects
    (User.count / GroupList::GROUP_SIZE) + 2
  end
end