module ProjectsHelper
  def self.selectable_projects(projects)
    projects[0...Settings.num_projects]
  end

  def upvote_link(project)
    return nil unless user_signed_in? && Settings.voting

    unless current_user.voted_on? project
      link_to raw('<i class="icon-arrow-up"></i>'), upvote_project_path(project), method: :post, remote: true
    else
      raw('<i class="icon-thumbs-up"></i>')
    end
  end
end
