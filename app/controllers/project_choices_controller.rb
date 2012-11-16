class ProjectChoicesController < ApplicationController
  # GET /project_choices
  # GET /project_choices.json
  def index
    @project_choices = ProjectChoice.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_choices }
    end
  end

  # GET /project_choices/1
  # GET /project_choices/1.json
  def show
    @project_choice = ProjectChoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_choice }
    end
  end

  # GET /project_choices/new
  # GET /project_choices/new.json
  def new
    @project_choice = ProjectChoice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_choice }
    end
  end

  # GET /project_choices/1/edit
  def edit
    @project_choice = ProjectChoice.find(params[:id])
  end

  # POST /project_choices
  # POST /project_choices.json
  def create
    @project_choice = ProjectChoice.new(params[:project_choice])

    respond_to do |format|
      if @project_choice.save
        format.html { redirect_to @project_choice, notice: 'Project choice was successfully created.' }
        format.json { render json: @project_choice, status: :created, location: @project_choice }
      else
        format.html { render action: "new" }
        format.json { render json: @project_choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_choices/1
  # PUT /project_choices/1.json
  def update
    @project_choice = ProjectChoice.find(params[:id])

    respond_to do |format|
      if @project_choice.update_attributes(params[:project_choice])
        format.html { redirect_to @project_choice, notice: 'Project choice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_choices/1
  # DELETE /project_choices/1.json
  def destroy
    @project_choice = ProjectChoice.find(params[:id])
    @project_choice.destroy

    respond_to do |format|
      format.html { redirect_to project_choices_url }
      format.json { head :no_content }
    end
  end
end
