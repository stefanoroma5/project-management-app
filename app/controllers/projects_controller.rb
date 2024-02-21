class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects or /projects.json
  # GET /projects?mode=m
  # GET /projects?mode=c
  def index
    if params[:mode].eql? "m"
      @projects = Project.owner(current_developer.id)
    end
    if params[:mode].eql? "c"
      @projects = Project.collaborate(current_developer.id)
    end
  end

  # GET /projects/1 or /projects/1.json
  def show
    @developers = Developer.collaborators(params[:id])
    @developer_projects = DeveloperProject.where(project_id: params[:id])
    @developer_project = DeveloperProject.new
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    developer = Developer.find(current_developer.id)

    @project.developer = developer
    @developer_project = DeveloperProject.new(developer: developer, project: @project, email: developer.email, status: "Active")

    respond_to do |format|
      if @project.save
        if @developer_project.save
          format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
          format.json { render :show, status: :created, location: @project }
        else
          format.html { render :new, alert: "Unprocessable entity. Errors: #{@developer_project.errors.full_messages.join(", ")}", status: :unprocessable_entity }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new, alert: "Unprocessable entity. Errors: #{@project.errors.full_messages.join(", ")}", status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)

        # se il progetto è stato terminato creo la notifica
        if @project.status.eql?("Finished")

          developer = Developer.find(@project.developer_id)
          @notification = developer.notifications.build(text: "The project " + @project.title + " was terminated", read: false)
          if @notification.save
            puts "Notification created"
          else
            puts @notification.errors.full_messages
          end

        end

        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }

      else

        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:title, :deadline, :customer, :description, :start_date, :end_date, :status)
  end
end
