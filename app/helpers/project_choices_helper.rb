module ProjectChoicesHelper
  def display_name(choice)
    choice.project.name
  end

  def enumerated_choice_label(form)
    form.label :project_id, "\##{form.object.priority.to_s}"
  end
end
