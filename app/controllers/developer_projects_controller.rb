class DeveloperProjectsController < ApplicationController
  before_action :set_developer_project, only: %i[ edit update destroy ]

    # GET /developer_projects/new
  def new
    @developer_project = DeveloperProject.new
  end

  # GET /developer_projects/1/edit
  def edit
  end

  # POST /developer_projects or /developer_projects.json
  def create
    developer = Developer.find_by(email: params["email"])
    project = Project.find(params["project_id"])
    @developer_project = DeveloperProject.new(developer_id: developer.id, project_id: project.id, email: developer.email)

    respond_to do |format|
      if @developer_project.save
        format.html { redirect_to project_url(project), notice: "Collaborator was successfully added." }
        format.json { render :show, status: :created, location: project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /developer_projects/1 or /developer_projects/1.json
  def destroy
    @developer_project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Collaborator was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_developer_project
      @developer_project = DeveloperProject.find(params[:id])
    end

end