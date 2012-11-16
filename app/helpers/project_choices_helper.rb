module ProjectChoicesHelper
  def display_name(choice)
    choice.project.name
  end
end
