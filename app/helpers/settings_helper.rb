module SettingsHelper
  def toggle_link_for(config)
    link_text = (Settings.send(config) ? 'Disable ' : 'Enable ') + config.capitalize
    link_to link_text, toggle_path(config), method: :post, class: 'btn'
  end
end
