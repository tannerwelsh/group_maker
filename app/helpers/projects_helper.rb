module ProjectsHelper
  def selectable_projects(projects)
    alphabetized_by_name(projects[0...Settings.num_projects])
  end

  def project_id_for(form)
    form.object.project.id if form.object.project
  end

  def probability_indicator(project)
    percentage = project.probability_for_acceptance

    percentage < 150 ? "#{percentage}%" : "Low interest"
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
