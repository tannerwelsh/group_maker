module ProjectsHelper
  def upvote_link(project)
    unless current_user.voted_on? project
      link_to raw('<i class="icon-arrow-up"></i>'), upvote_project_path(project), method: :post, remote: true
    else
      raw('<i class="icon-minus"></i>')
    end
  end
end
