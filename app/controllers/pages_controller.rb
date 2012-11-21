class PagesController < ApplicationController
  def home
    @projects = Project.sorted_by_votes
    @users    = User.alphabetized.includes(:choices)

    @user_project = current_user.project if user_signed_in? && current_user.has_project?
  end
end
