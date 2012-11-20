module UsersHelper

  def choice_project_title(user, choice_no)
    user.choice(choice_no).project_name
  end
end
