class SettingsController < ApplicationController

  def index
    @settings = {
      voting:  Settings.permit_voting,
      choices: Settings.permit_choices
    }
  end

  def toggle
    case params[:config]
    when 'voting'
      Settings.permit_voting = !Settings.permit_voting
    when 'choices'  
      Settings.permit_choices = !Settings.permit_choices
    end

    redirect_to action: 'index'
  end

end
