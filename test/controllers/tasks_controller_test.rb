require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:task_two)
    @project = projects(:project_two)
    @task_params = {
      title: "Task Title",
      start_date: Date.today,
      end_date: Date.today + 30,
      status: "Started",
      description: "Task Description",
      task_type: "Feature",
      estimation: 10,
      priority: "High"
    }
    @developer_emails = [developers(:john_doe).email, developers(:jane_doe).email]
  end

  test "should get index" do
    get project_tasks_url(@project)
    assert_response :success
  end

  test "should get new" do
    get new_project_task_url(@project)
    assert_response :success
  end

  test "should create task with valid params and developers" do
    assert_difference("Task.count") do
      post project_tasks_url(@project), params: {task: @task_params, developer_emails: @developer_emails}
    end

    assert_redirected_to project_task_url(@project, Task.last)
  end

  test "should create task with valid params and no developers" do
    assert_difference("Task.count") do
      post project_tasks_url(@project), params: {task: @task_params}
    end

    assert_redirected_to project_task_url(@project, Task.last)
  end

  test "should not create task with invalid params" do
    assert_no_difference("Task.count") do
      post project_tasks_url(@project), params: {task: @task_params.merge(title: nil), developer_emails: @developer_emails}
    end

    assert_response :unprocessable_entity
  end

  test "should show task" do
    get project_task_url(@project, @task)
    assert_response :success
  end

  # test "should get edit" do
  #   get edit_task_url(@task)
  #   assert_response :success
  # end

  # test "should update task" do
  #   patch task_url(@task), params: {task: {description: @task.description, end_date: @task.end_date, estimation: @task.estimation, priority: @task.priority, start_date: @task.start_date, status: @task.status, title: @task.title, task_type: @task.task_type}}
  #   assert_redirected_to task_url(@task)
  # end

  test "should destroy task and task_label and developer_task but not label project developer" do
    assert_no_difference("Developer.count") do
      assert_no_difference("Project.count") do
        assert_no_difference("Label.count") do
          assert_difference("DeveloperTask.count", -1) do
            assert_difference("TasksLabel.count", -1) do
              assert_difference("Task.count", -1) do
                delete project_task_url(@project, @task)
              end
            end
          end
        end
      end
    end

    assert_redirected_to project_task_url(@project, @task)
  end
end
