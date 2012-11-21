class AdminController < ApplicationController

  def index
    @settings = Settings::CONFIG
  end

  def toggle
    Settings.toggle!(params[:config])
    
    redirect_to action: 'index'
  end

end
