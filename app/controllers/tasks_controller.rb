class TasksController < ApplicationController
  before_action :set_project, only: [:new, :create, :show, :edit, :update, :destroy, :index, :start, :finish]
  before_action :set_task, only: [:show, :edit, :update, :destroy, :start, :finish]

  # GET /tasks or /tasks.json
  def index
    @tasks = @project.tasks
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET projects/tasks/new
  def new
    @task = @project.tasks.build
  end

  # GET /tasks/1/edit
  def edit
    @available_labels = Label.where.not(id: @task.labels.ids)
    @available_developers = @project.developer_projects.where(status: "Active").where.not(developer_id: @task.developer_tasks.pluck(:developer_id)).map(&:developer)
  end

  # POST /tasks or /tasks.json
  def create
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
    @task.developer_tasks.each do |developer_task|
      developer_task.developer.notifications.create(text: "The task #{@task.title} of project #{@project.title} has been deleted.", read: false)
    end

    @task.destroy

    respond_to do |format|
      format.html { redirect_to project_tasks_path(@project), notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_developer
    @task = Task.find(params[:id])
    developer = Developer.find(params[:developer_id])
    unless @task.developers.include?(developer)
      @task.developers << developer
      notification = developer.notifications.build(text: "You have been assigned to the task " + @task.title + " of project " + @task.project.title, read: false)
      if notification.save
        puts "Notification created. To #{developer.email}: #{notification.text}"
      else
        puts notification.errors.full_messages
      end
    end

    respond_to do |format|
      if @task.save
        format.html { redirect_to edit_project_task_path(@task.project, @task), notice: "Owner was successfully added." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :show, alert: "Unprocessable entity. Errors: #{@task.errors.full_messages.join(", ")}", status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_developer
    @task = Task.find(params[:id])
    developer = Developer.find(params[:developer_id])
    @task.developers.delete(developer)
    notification = developer.notifications.build(text: "You have been removed from the task " + @task.title + " of project " + @task.project.title, read: false)
    if notification.save
      puts "Notification created. To #{developer.email}: #{notification.text}"
    else
      puts notification.errors.full_messages
    end

    respond_to do |format|
      format.html { redirect_to edit_project_task_path(@task.project, @task), notice: "Owner was successfully removed." }
      format.json { head :no_content }
    end
  end

  def add_label
    @task = Task.find(params[:id])
    label = Label.find(params[:label_id])
    @task.labels << label unless @task.labels.include?(label)

    respond_to do |format|
      if @task.save
        format.html { redirect_to edit_project_task_path(@task.project, @task), notice: "Label was successfully added." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :show, alert: "Unprocessable entity. Errors: #{@task.errors.full_messages.join(", ")}", status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_label
    @task = Task.find(params[:id])
    label = Label.find(params[:label_id])
    if @task.labels.include?(label)
      @task.labels.delete(label)
    end

    respond_to do |format|
      format.html { redirect_to edit_project_task_path(@task.project, @task), notice: "Label was successfully removed." }
      format.json { head :no_content }
    end
  end

  def start
    respond_to do |format|
      if @task.update(status: "Started", start_date: Date.today, end_date: nil)
        format.html { redirect_to project_tasks_path(@project), notice: "Task was successfully started." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :show, alert: "Unprocessable entity. Errors: #{task.errors.full_messages.join(", ")}", status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def finish
    respond_to do |format|
      if @task.update(status: "Finished", end_date: Date.today)
        @task.developer_tasks.each do |developer_task|
          developer_task.developer.notifications.create(text: "The task #{@task.title} of project #{@project.title} has been finished.", read: false)
        end
        format.html { redirect_to project_tasks_path(@project), notice: "Task was successfully finished." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :show, alert: "Unprocessable entity. Errors: #{task.errors.full_messages.join(", ")}", status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
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
