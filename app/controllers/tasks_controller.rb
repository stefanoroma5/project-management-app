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
    @task = @project.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = @project.tasks.build(task_params)
    process_successful = true

    # Add developers to the task
    if params[:developer_ids].present?
      developer_ids = params[:developer_ids]
      developer_ids.each do |developer_id|
        developer = Developer.find_by(id: developer_id)
        @task.developer_tasks.build(developer: developer)
        # Create a notification for each developer
        notification = developer.notifications.build(text: "You have been assigned to the task " + @task.title + " of project " + @project.title, read: false)
        if notification.save
          puts "Notification created. To #{developer.email}: #{notification.text}"
        else
          puts notification.errors.full_messages
          process_successful = false
          break # Exit the loop if saving fails
        end
      end
    end

    respond_to do |format|
      if @task.save && process_successful
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
    ActiveRecord::Base.transaction do
      process_successful = true

      if @task.update(task_params)
        puts "Task updated successfully."
      else
        process_successful = false
        puts @task.errors.full_messages
        raise ActiveRecord::Rollback
      end

      # Step 2: Update developers assigned to the task
      if params[:developer_ids].present?
        developer_ids = params[:developer_ids].map(&:to_i) # Ensure IDs are integers
        developer_tasks_ids = @task.developer_tasks.pluck(:developer_id)

        # Add new developers to the task
        (developer_ids - developer_tasks_ids).each do |id|
          developer_task = @task.developer_tasks.build(developer_id: id)
          unless developer_task.save
            process_successful = false
            puts "Error: developer_task.save failed."
            raise ActiveRecord::Rollback
          end
          notification = developer_task.developer.notifications.build(text: "You have been assigned to the task " + @task.title + " of project " + @project.title, read: false)
          unless notification.save
            puts notification.errors.full_messages
            process_successful = false
            raise ActiveRecord::Rollback
          end
        end

        # Remove unselected developers from the task
        (developer_tasks_ids - developer_ids).each do |id|
          developer_task = @task.developer_tasks.find_by(developer_id: id)
          unless developer_task.destroy
            process_successful = false
            puts "Error: developer_task.destroy failed."
            raise ActiveRecord::Rollback
          end
          notification = developer_task.developer.notifications.build(text: "You have been removed from the task " + @task.title + " of project " + @project.title, read: false)
          unless notification.save
            puts notification.errors.full_messages
            process_successful = false
            raise ActiveRecord::Rollback
          end
        end
      elsif @task.developer_tasks.present?
        # Remove all developers from the task
        @task.developer_tasks.each do |developer_task|
          unless developer_task.destroy
            process_successful = false
            puts "Error: developer_task.destroy failed."
            raise ActiveRecord::Rollback
          end
          notification = developer_task.developer.notifications.build(text: "You have been removed from the task " + @task.title + " of project " + @project.title, read: false)
          unless notification.save
            puts notification.errors.full_messages
            process_successful = false
            raise ActiveRecord::Rollback
          end
        end
      end

      respond_to do |format|
        if process_successful
          format.html { redirect_to project_task_url(@project, @task), notice: "Task was successfully updated." }
          format.json { render :show, status: :ok, location: @task }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      end
    end
  rescue ActiveRecord::Rollback
    render :edit, alert: "Failed to update task."
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
