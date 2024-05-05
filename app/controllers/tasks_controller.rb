class TasksController < ApplicationController
  before_action :set_project, only: [:new, :create, :show, :edit, :update, :destroy, :index]
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks or /tasks.json
  def index
    @tasks = @project.tasks
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET projects/tasks/new
  def new
    @project = Project.find(params[:project_id])
    @task = @project.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @project = Project.find(params[:project_id])
    # add the task to the project
    @task = @project.tasks.build(task_params)

    # Assuming developer_ids is an array of developer ids passed in params
    if params["developer_emails"].present?
      developer_emails = params["developer_emails"]

      developer_emails.each do |developer_email|
        developer = Developer.find_by(email: developer_email)
        @developer_task = DeveloperTask.new(developer: developer, task: @task)
      end
    end

    respond_to do |format|
      if params["developer_emails"].present?
        saved = @task.save && @developer_task.save && @project.save
        error_object = @developer_task.errors.any? ? @developer_task : @task.errors.any? ? @task : @project
      else
        saved = @task.save && @project.save
        error_object = @task.errors.any? ? @task : @project
      end

      if saved
        format.html { redirect_to project_task_url(@project, @task), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, alert: "Unprocessable entity. Errors: #{error_object.errors.full_messages.join(", ")}", status: :unprocessable_entity }
        format.json { render json: error_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to project_task_url(@project, @task), notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:start_date, :end_date, :status, :description, :task_type, :estimation, :priority, :title)
  end
end
