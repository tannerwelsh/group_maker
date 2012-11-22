module AdminHelper
  def toggle_link_for(config)
    toggle_type = Settings.send(config) ? 'Disable' : 'Enable'
    link_text   = toggle_type + ' ' + snake_to_string(config)

    link_to link_text, toggle_path(config), method: :post, class: "btn #{setting_class(config)}"
  end

  def snake_to_string(string)
    string.to_s.split('_').map(&:capitalize).join(' ')
  end

  def setting_class(config)
    Settings.send(config) ? 'btn-danger' : 'btn-success'
  end
end
