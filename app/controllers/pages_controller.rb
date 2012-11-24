class PagesController < ApplicationController
  skip_authorization_check

  def home
    @projects = Project.sorted_by_votes
    @users    = User.students.alphabetized.includes(:choices => [:project])
    @user     = current_user || User.new

    @choices  = @user.load_choices

    @user_project = current_user.project if user_signed_in? && current_user.has_project?
  end
end
