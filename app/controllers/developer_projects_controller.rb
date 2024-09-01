class DeveloperProjectsController < ApplicationController
  before_action :set_developer_project, only: %i[edit update destroy]

  def new
    @developer_project = DeveloperProject.new
  end

  def create
    developer = Developer.find_by(email: params["email"])
    project = Project.find(params["project_id"])
    @developer_project = DeveloperProject.new(developer: developer, project: project, email: params["email"], status: "Active")

    existing_record = DeveloperProject.find_by(developer: developer, project: project, email: params["email"])

    respond_to do |format|
      if existing_record
        # Se il record esiste già, restituisco un messaggio di errore
        format.html { redirect_to project_url(project), alert: "Collaboratory already exist. Errors: #{@developer_project.errors.full_messages.join(", ")}", status: :unprocessable_entity }
        format.json { render json: project_url.errors, status: :unprocessable_entity }
      elsif @developer_project.save
        format.html { redirect_to project_url(project), notice: "Collaborator was successfully added." }
        format.json { render :show, status: :created, location: project }

        notification = developer.notifications.build(text: "You have been added to the project " + project.title, read: false)
        if notification.save
          puts "Notification created"
        else
          puts notification.errors.full_messages
        end
      else
        format.html { redirect_to project_url(project), alert: "Unprocessable entity. Errors: #{@developer_project.errors.full_messages.join(", ")}", status: :unprocessable_entity }
        format.json { render json: project_url.errors, status: :unprocessable_entity }
      end
    end
  end

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
        format.html { redirect_to project_url(project), alert: "Unprocessable entity. Errors: #{@developer_project.errors.full_messages.join(", ")}", status: :unprocessable_entity }
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
