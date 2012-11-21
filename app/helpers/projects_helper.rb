module ProjectsHelper
  def self.selectable_projects(projects)
    projects[0...num_of_allowed_projects]
  end

  def self.num_of_allowed_projects
    (User.count / GroupList::GROUP_SIZE) + 2
  end

  def upvote_link(project)
    return nil unless user_signed_in? && Project.voting_allowed?

    unless current_user.voted_on? project
      link_to raw('<i class="icon-arrow-up"></i>'), upvote_project_path(project), method: :post, remote: true
    else
      raw('<i class="icon-thumbs-up"></i>')
    end
  end
end
