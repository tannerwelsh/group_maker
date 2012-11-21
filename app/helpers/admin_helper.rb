module AdminHelper
  def toggle_link_for(config)
    toggle_type = Settings.send(config) ? 'Disable' : 'Enable'
    link_text   = toggle_type + ' ' + config.capitalize

    link_to link_text, toggle_path(config), method: :post, class: "btn #{setting_class(config)}"
  end

  def setting_class(config)
    Settings.send(config) ? 'btn-danger' : 'btn-success'
  end
end
