class PagesController < ApplicationController
  def home
    @projects            = Project.sorted_by_votes
    @selectable_projects = ProjectsHelper.selectable_projects(@projects)
    @users               = User.alphabetized.includes(:choices)
  end
end
