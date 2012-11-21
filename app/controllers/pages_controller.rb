class PagesController < ApplicationController
  def home
    @projects = Project.sorted_by_votes
    @users    = User.alphabetized.includes(:choices)
  end
end
