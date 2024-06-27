class DeveloperTasksController < ApplicationController
  before_action :set_project_and_task
  before_action :set_developer_task, only: [:edit, :update, :destroy]

  def new
    @developer_task = @task.developer_tasks.build
  end

  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:task_id])
    @developer_task = nil
    notification = nil

    # Add developers to the task
    if params[:developer_ids].present?
      developer_ids = params[:developer_ids]
      developer_ids.each do |developer_id|
        developer_task = @task.developer_tasks.build(developer_id: developer_id, task_id: @task.id)
        developer_task.save
        developer = Developer.find(developer_id)
        notification = developer.notifications.build(text: "You have been assigned to the task " + @task.title + " of project " + @project.title, read: false)
      end
    end

    respond_to do |format|
      if @developer_task.save
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

  def edit
  end

  def update
    # find the developers' ids from developer_tasks associated to the task (already present associations)
    developer_tasks_ids = @task.developer_tasks.pluck(:developer_id)
    # find the developer_projects' ids associated to this task's project (all choices)
    developer_project_ids = @project.developer_projects.pluck(:developer_id)
    notification = nil

    # Update developers assigned to the task
    if params[:developer_ids].present?
      developer_ids = params[:developer_ids] # developers selected by the user
      developer_project_ids.each do |id|
        developer = Developer.find(id)
        if developer_ids.include?(id) && !developer_tasks_ids.include?(id)
          developer_task = @task.developer_tasks.build(developer_id: developer_id, task_id: @task.id)
          developer_task.save
          notification = developer.notifications.build(text: "You have been assigned to the task " + @task.title + " of project " + @project.title, read: false)
        elsif !developer_ids.include?(id) && developer_tasks_ids.include?(id)
          developer_task = @task.developer_tasks.find_by(developer_id: id)
          developer_task.destroy
          notification = developer.notifications.build(text: "You have been removed from the task " + @task.title + " of project " + @project.title, read: false)
        end
      end
    end

    respond_to do |format|
      if @developer_task.save
        if !notification.nil? && notification.save
          puts "Notification created"
        else
          puts notification.errors.full_messages
        end
        format.html { redirect_to project_task_url(@project, @task), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :edit, alert: "Unprocessable entity. Errors: #{@task.errors.full_messages.join(", ")}", status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_project_and_task
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:task_id])
  end

  def set_developer_task
    @developer_task = @task.developer_tasks.find(params[:id])
  end

  def developer_task_params
    params.require(:developer_task).permit(:developer_id, :task_id, developer_ids: [])
  end
end
