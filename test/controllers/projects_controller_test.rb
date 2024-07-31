require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @developer = developers(:john_doe)
    sign_in @developer
    @project_params = {
      title: "Project Title",
      deadline: Date.today + 30,
      customer: "Test Customer",
      description: "Project Description",
      status: "Started",
      developer: @developer
    }
    @project = projects(:project_one)
  end

  # Testing index
  test "should get index with mode m" do
    get projects_url, params: {mode: "m"}
    assert_response :success
    Project.owner(@developer.id).each do |project|
      assert_match project.title, @response.body
    end
  end

  test "should get index with mode c" do
    get projects_url, params: {mode: "c"}
    assert_response :success
    Project.collaborate(@developer.id).each do |project|
      assert_match project.title, @response.body
    end
  end

  # Testing show
  test "should show project" do
    get project_url(@project)
    assert_response :success
  end

  # Testing new
  test "should get new" do
    get new_project_url
    assert_response :success
  end

  # Testing create
  test "should create project and developer_project with valid attributes" do
    assert_difference ["Project.count", "DeveloperProject.count"], 1 do
      post projects_url, params: {project: @project_params}
    end
    assert_redirected_to project_url(Project.last)
    assert_equal "Project was successfully created.", flash[:notice]
  end

  test "should not create project with invalid attributes" do
    assert_no_difference ["Project.count", "DeveloperProject.count"] do
      post projects_url, params: {project: @project_params.merge(title: nil)}
    end
    assert_response :unprocessable_entity
  end

  # Testing update
  test "should update project with valid attributes" do
    patch project_url(@project), params: {project: {title: "Updated Title"}}
    assert_redirected_to project_url(@project)
    assert_equal "Project was successfully updated.", flash[:notice]
    @project.reload
    assert_equal "Updated Title", @project.title
  end

  test "should not update project with invalid attributes" do
    patch project_url(@project), params: {project: {title: nil}}
    assert_response :unprocessable_entity
  end

  test "should finish project and send a notification for each developer" do
    assert_difference("Notification.count", 1) do
      patch finish_project_path(@project)
    end

    assert_redirected_to project_url(@project)
  end

  # Testing cancel
  test "should cancel project with valid id" do
    patch cancel_project_url(@project)
    assert_redirected_to project_url(@project)
    assert_equal "Project was successfully Cancelled.", flash[:notice]
    @project.reload
    assert_equal "Cancelled", @project.status
  end

  test "should not cancel project with invalid id" do
    assert_raises(ActiveRecord::RecordNotFound) do
      patch cancel_project_url(-1)
    end
  end
end
