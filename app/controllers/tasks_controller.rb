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
    @developer_tasks = @task.developer_tasks.build
  end

  # GET /tasks/1/edit
  def edit
    @developer_tasks = @task.developer_tasks
  end

  # POST /tasks or /tasks.json
  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to project_task_url(@project, @task), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, alert: "Unprocessable entity. Errors: #{@task.errors.full_messages.join(", ")}", status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to project_task_url(@project, @task), notice: "Task was successfully updated." }
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
    params.require(:task).permit(:start_date, :end_date, :status, :description, :task_type, :estimation, :priority, :title, developer_tasks_attributes: [:developer_id, :task_id, developer_ids: []])
  end
end
