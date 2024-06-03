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
    @task = @project.tasks.build(task_params)
    notification = nil

    # Add developers to the task
    if params[:task][:developer_ids].present?
      developer_ids = params[:task][:developer_ids]
      developer_ids.each do |developer_id|
        @task.developer_tasks.build(developer_id: developer_id)
        developer = Developer.find(developer_id)
        notification = developer.notifications.build(text: "You have been assigned to the task " + @task.title + " of project " + @project.title, read: false)
      end
    end

    respond_to do |format|
      if @task.save
        if !notification.nil? && notification.save
          puts "Notification created"
        else
          puts notification.errors.full_messages
        end
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
      # destroy all developers assigned to the task
      if @task.update(task_params)
        @task.developer_tasks.destroy_all

        if params[:task][:developer_ids].present?
          developer_ids = params[:task][:developer_ids]
          developer_ids.each do |developer_id|
            @task.developer_tasks.build(developer_id: developer_id)
          end
        end

        if @task.save
          format.html { redirect_to project_task_url(@project, @task), notice: "Task was successfully updated." }
          format.json { render :show, status: :ok, location: @task }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
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
    params.require(:task).permit(:start_date, :end_date, :status, :description, :task_type, :estimation, :priority, :title, developer_tasks: [])
  end
end
