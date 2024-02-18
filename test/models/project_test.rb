require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  # Testing the validations
  test "should not be created" do
    refute Project.new.valid?
  end

  test "should be created with developer from fixture" do
    developer = developers(:john_doe)
    assert Project.new(
      title: "Test Project",
      deadline: Date.today + 30,
      customer: "Test Customer",
      description: "Test Description",
      status: "Unstarted",
      start_date: Date.today,
      end_date: Date.today + 30,
      developer: developer
    ).valid?
  end

  test "should have a title" do
    project = Project.new(
      deadline: Date.today + 30,
      customer: "Test Customer",
      description: "Test Description",
      status: "Unstarted",
      start_date: Date.today,
      end_date: Date.today + 30
    )
    refute project.valid?
    assert_includes project.errors[:title], "can't be blank"
  end

  test "should have a deadline" do
    project = Project.new(
      title: "Test Project",
      customer: "Test Customer",
      description: "Test Description",
      status: "Unstarted",
      start_date: Date.today,
      end_date: Date.today + 30
    )
    refute project.valid?
    assert_includes project.errors[:deadline], "can't be blank"
  end

  test "should have a customer with only letters and spaces" do
    project = Project.new(
      title: "Test Project",
      deadline: Date.today + 30,
      customer: "Test123",
      description: "Test Description",
      status: "Unstarted",
      start_date: Date.today,
      end_date: Date.today + 30
    )
    refute project.valid?
    assert_includes project.errors[:customer], "only allows letters and spaces"
  end

  test "should have a description" do
    project = Project.new(
      title: "Test Project",
      deadline: Date.today + 30,
      customer: "Test Customer",
      status: "Unstarted",
      start_date: Date.today,
      end_date: Date.today + 30
    )
    refute project.valid?
    assert_includes project.errors[:description], "can't be blank"
  end

  test "deadline should not be in the past" do
    project = Project.new(
      title: "Test Project",
      deadline: Date.today - 1,
      customer: "Test Customer",
      description: "Test Description",
      status: "Unstarted",
      start_date: Date.today,
      end_date: Date.today + 30
    )
    refute project.valid?
    assert_includes project.errors[:deadline], "can't be in the past"
  end

  test "start date should not be in the past" do
    project = Project.new(
      title: "Test Project",
      deadline: Date.today + 30,
      customer: "Test Customer",
      description: "Test Description",
      status: "Unstarted",
      start_date: Date.today - 1,
      end_date: Date.today + 30
    )
    refute project.valid?
    assert_includes project.errors[:start_date], "can't be in the past"
  end

  test "end date should not be in the past" do
    project = Project.new(
      title: "Test Project",
      deadline: Date.today + 30,
      customer: "Test Customer",
      description: "Test Description",
      status: "Unstarted",
      start_date: Date.today,
      end_date: Date.today - 1
    )
    refute project.valid?
    assert_includes project.errors[:end_date], "can't be in the past"
  end

  test "start date has to be smaller than deadline" do
    project = Project.new(
      title: "Test Project",
      deadline: Date.today + 10,
      customer: "Test Customer",
      description: "Test Description",
      status: "Unstarted",
      start_date: Date.today + 20,
      end_date: Date.today + 30
    )
    refute project.valid?
    assert_includes project.errors[:start_date], "can't be after deadline"
  end

  test "end date has to be greater than start date" do
    project = Project.new(
      title: "Test Project",
      deadline: Date.today + 30,
      customer: "Test Customer",
      description: "Test Description",
      status: "Unstarted",
      start_date: Date.today + 20,
      end_date: Date.today + 1
    )
    refute project.valid?
    assert_includes project.errors[:end_date], "can't be earlier than start date"
  end

  test "status should be one of the allowed values" do
    project = Project.new(
      title: "Test Project",
      deadline: Date.today + 30,
      customer: "Test Customer",
      description: "Test Description",
      status: "Invalid State",
      start_date: Date.today,
      end_date: Date.today + 30
    )
    refute project.valid?
    assert_includes project.errors[:status], "#{project.status} is not a valid status"
  end

  test "status should be present" do
    project = Project.new(
      title: "Test Project",
      deadline: Date.today + 30,
      customer: "Test Customer",
      description: "Test Description",
      start_date: Date.today,
      end_date: Date.today + 30
    )
    refute project.valid?
    assert_includes project.errors[:status], "can't be blank"
  end

  # Testing the associations
  test "project should belong to a developer" do
    developer = Developer.create(name: "John Doe")
    project = Project.new(
      title: "Test Project",
      deadline: Date.today + 30,
      customer: "Test Customer",
      description: "Test Description",
      status: "Unstarted",
      start_date: Date.today,
      end_date: Date.today + 30,
      developer: developer
    )
    assert project.save
    assert_equal developer, project.developer
  end

  test "project has many tasks and tasks are correctly associated" do
    project = projects(:project_one)
    task1 = project.tasks.create(title: "Test Task 1", description: "This is a test task")
    task2 = project.tasks.create(title: "Test Task 2", description: "This is another test task")

    assert_includes project.tasks, task1, "Project should include the first task"
    assert_includes project.tasks, task2, "Project should include the second task"

    assert_equal task1.project, project, "Task1's project should be the project it was created for"
    assert_equal task2.project, project, "Task2's project should be the project it was created for"

    task1.destroy
    task2.destroy
  end

  test "projects have many developers and vice versa" do
    project_one = projects(:project_one)
    project_two = projects(:project_two)
    john = developers(:john_doe)
    jane = developers(:jane_doe)

    assert_includes project_one.developers, john, "Project one should include John as a developer"
    assert_includes project_two.developers, jane, "Project two should include Jane as a developer"

    assert_includes john.projects, project_one, "John should be included in the project one's developers"
    assert_includes jane.projects, project_two, "Jane should be included in the project two's developers"

    assert_equal 1, project_one.developers.count, "Project one should have one developer"
    assert_equal 1, project_two.developers.count, "Project two should have one developer"
    assert_equal 1, john.projects.count, "John should be associated with one project"
    assert_equal 1, jane.projects.count, "Jane should be associated with one project"
  end

  # Testing the scopes
  test "should filter projects by status" do
    assert_includes Project.unstarted, projects(:project_one), "Unstarted scope should include unstarted projects"
    assert_includes Project.started, projects(:project_two), "Started scope should include started projects"
    assert_includes Project.finished, projects(:project_three), "Finished scope should include finished projects"
  end

  test "should filter projects that are overdue" do
    assert_includes Project.overdue, projects(:project_four), "Overdue scope should include projects that are past their deadline"
    refute_includes Project.overdue, projects(:project_one), "Overdue scope should not include projects with future deadline"
  end

  test "should filter projects by recent start date" do
    assert_includes Project.recent, projects(:project_two), "Recent scope should include projects started recently"
    refute_includes Project.recent, projects(:project_five), "Recent scope should not include older projects"
  end

  test "should filter projects by owner" do
    johns_projects = Project.owner(developers(:john_doe).id)
    assert_includes johns_projects, projects(:project_one), "Owner scope should include projects owned by specified developer"
    refute_includes johns_projects, projects(:project_two), "Owner scope should not include projects not owned by specified developer"
  end

  test "should filter projects by collaborators" do
    johns_collaborations = Project.collaborate(developers(:john_doe).id)
    assert_includes johns_collaborations, projects(:project_one), "Collaborate scope should include projects where the developer is a collaborator"
    refute_includes johns_collaborations, projects(:project_two), "Collaborate scope should not include projects where the developer is not a collaborator"
  end
  # If your application includes specific business logic within the model (not seen in the provided code), 
  # ensure to write tests for those methods. For example, methods that calculate project duration, budget, 
  # or progress status based on associated tasks or developer contributions.
end
