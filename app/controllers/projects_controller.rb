class ProjectsController < ApplicationController
  before_filter :generate_empty_choices, only: [:index]
  before_filter :check_if_voting_allowed, only: [:upvote]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.includes(:members)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    return redirect_to root_path unless user_signed_in?

    @project = Project.new
    @users   = User.alphabetized

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to root_path, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to root_path, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  def upvote
    @project = Project.find(params[:id])
    @project.vote voter: current_user

    @projects = Project.sorted_by_votes

    respond_to do |format|
      format.js   { render 'upvote'}
      format.html { redirect_to projects_url }
      format.json { render json: @project }
    end
  end

private
  
  def generate_empty_choices
    if user_signed_in? && !current_user.has_choices?
      current_user.generate_empty_choices
    end
  end

  def check_if_voting_allowed
    redirect_to root_path, notice: 'Voting is closed.' unless Settings.voting
  end
end
