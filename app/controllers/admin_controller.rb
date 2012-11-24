class AdminController < ApplicationController
  before_filter :authorize_settings, only: [:index, :toggle]
  before_filter :authorize_group_management, except: [:toggle]

  def index
    @settings = Settings.config
  end

  def toggle
    Settings.toggle!(params[:config])
    
    redirect_to action: 'index'
  end

  def make_groups
    loop_times = (params[:loop_times] || 1).to_i

    loop_times.times do
      GroupList.generate!
    end

    redirect_to projects_path
  end

  def destroy_groups
    GroupList.destroy_all!

    redirect_to projects_path
  end

private

  def authorize_settings
    authorize! :manage, Settings
  end

  def authorize_group_management
    authorize! :manage, GroupList
  end

end
