module ApplicationHelper
  def alphabetized_by_name(collection)
    collection.sort_by(&:name)
  end
end
