class AdminController < ApplicationController

  def index
    @settings = Settings::CONFIG
  end

  def toggle
    Settings.toggle!(params[:config])
    
    redirect_to action: 'index'
  end

  def make_groups
    GroupList.generate!

    redirect_to projects_path
  end

end
