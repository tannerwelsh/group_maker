module SettingsHelper
  def toggle_link_for(config)
    link_text = (Settings.send('permit_' + config.to_s) ? 'Disable ' : 'Enable ') + config.to_s.capitalize
    link_to link_text, toggle_path(config), method: :post, class: 'btn'
  end
end
