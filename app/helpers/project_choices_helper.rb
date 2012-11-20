module ProjectChoicesHelper
  def display_name(choice)
    choice.project.name
  end

  def enumerated_choice_label(form)
    form.label :project_id, 'Project Choice #' + form.object.priority.to_s
  end

  def project_id_for(form)
    form.object.project.id
  end
end
