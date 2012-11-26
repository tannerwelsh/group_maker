module ProjectsHelper
  def selectable_projects(projects)
    alphabetized_by_name(projects[0...Settings.num_projects])
  end

  def project_id_for(form)
    form.object.project_id if form.object.project_id
  end

  def probability_indicator(project)
    percentage = project.probability_for_acceptance

    case
    when percentage >= 150
      "Interest too low"
    when 100 < percentage && percentage < 150
      "Outlook looks good"
    else
      "#{percentage}%"
    end
  end

  def members_colorized_by_choice(project)
    html = project.members.map do |member|
      if member == project.creator
        css_class = 'project_creator'
      elsif project.choice_for(member)
        css_class = class_for_priority(project.choice_for(member).priority)
      else
        css_class = class_for_priority(0)
      end

      "<span class=\"#{css_class}\">#{member.name}</span>"
    end.join(' | ')

    return raw(html)
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
