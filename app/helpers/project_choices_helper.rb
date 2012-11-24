module ProjectChoicesHelper
  def display_name(choice)
    choice ? choice.project_name : "nil"
  end

  def enumerated_choice_label(form)
    form.label :project_id, "\##{form.object.priority.to_s}"
  end

  def class_for_priority(choice)
    case choice.priority
    when 1
      'first_choice'
    when 2
      'second_choice'
    when 3
      'third_choice'
    else
      'no_choice'
    end
  end
end
