require "test_helper"

class DeveloperTest < ActiveSupport::TestCase
  def setup
    @developer = Developer.new(
      name: "John",
      lastname: "Doe",
      email: "test@example.com",
      password: "Password123!"
    )
  end

  # Testing the validations
  test "should be valid with valid attributes" do
    assert @developer.valid?
  end

  test "should not be valid without name" do
    @developer.name = nil
    refute @developer.valid?
  end

  test "should not be valid without lastname" do
    @developer.lastname = nil
    refute @developer.valid?
  end

  test "should not be valid without email" do
    @developer.email = nil
    refute @developer.valid?
  end

  test "should not be valid without password" do
    @developer.password = nil
    refute @developer.valid?
  end

  # Testing the associations
  test "should have many projects" do
    assert_respond_to @developer, :projects
  end

  test "should have many developer_projects" do
    assert_respond_to @developer, :developer_projects
  end

  test "should have many tasks" do
    assert_respond_to @developer, :tasks
  end

  test "should have many developer_tasks" do
    assert_respond_to @developer, :developer_tasks
  end

  test "should have many notifications" do
    assert_respond_to @developer, :notifications
  end

  # Testing the scopes
  test "should return recent developers" do
    old_developer = Developer.create(
      name: "Old",
      lastname: "Developer",
      email: "old@example.com",
      password: "Password123!",
      created_at: 1.month.ago
    )
    @developer.update(created_at: 1.week.ago)
    assert_includes Developer.recent, @developer
    refute_includes Developer.recent, old_developer
  end

  test "should return collaborators for a project" do
    project = Project.create(
      title: "Test Project",
      deadline: Date.today + 1.month,
      customer: "Test Customer",
      description: "Test Description",
      start_date: Date.today,
      end_date: Date.today + 1.month,
      status: "Unstarted",
      developer: @developer
    )
    DeveloperProject.create(developer: @developer, project: project, email: @developer.email, status: "Active")
    assert_includes Developer.collaborators(project.id), @developer
  end
end
