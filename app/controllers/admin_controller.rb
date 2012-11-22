class AdminController < ApplicationController

  def index
    authorize! :manage, Settings

    @settings = Settings.config
  end

  def toggle
    authorize! :manage, Settings

    Settings.toggle!(params[:config])
    
    redirect_to action: 'index'
  end

  def make_groups
    authorize! :manage, GroupList

    GroupList.generate!

    redirect_to projects_path
  end

end
