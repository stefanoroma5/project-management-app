class DeveloperProjectsController < ApplicationController
  before_action :set_developer_project, only: %i[edit update destroy]

  # GET /developer_projects/new
  def new
    @developer_project = DeveloperProject.new
  end

  # POST /developer_projects or /developer_projects.json
  def create
    developer = Developer.find_by(email: params["email"])
    project = Project.find(params["project_id"])
    @developer_project = DeveloperProject.new(developer: developer, project: project, email: developer.email, status: "Active")

    respond_to do |format|
      if @developer_project.save
        format.html { redirect_to project_url(project), notice: "Collaborator was successfully added." }
        format.json { render :show, status: :created, location: project }
      else
        format.html { redirect_to project_url(project), alert: "Unprocessable entity. Errors: #{@developer_project.errors.full_messages.join(", ")}", status: :unprocessable_entity }
        format.json { render json: project_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /developer_projects/1 or /developer_projects/1.json
  def update
    project = Project.find(params[:project_id])
    @developer_project.developer_id = params[:developer_id]
    @developer_project.project_id = params[:project_id]
    @developer_project.email = params[:email]
    @developer_project.status = params[:status]

    respond_to do |format|
      if @developer_project.save
        format.html { redirect_to project_url(project), notice: "Collaborator status was successfully changed." }
        format.json { render :show, status: :created, location: project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: project.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_developer_project
    @developer_project = DeveloperProject.find(params[:id])
  end
end
