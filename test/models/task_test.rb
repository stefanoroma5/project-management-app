require "test_helper"

class TaskTest < ActiveSupport::TestCase
  # Testing the validations
  test "should not be created" do
    refute Task.new.valid?
  end

  test "should be created with project from fixture" do
    project = projects(:project_one)
    assert Task.new(
      start_date: Date.today,
      end_date: Date.today + 30,
      status: "Unstarted",
      title: "Test Task",
      description: "Test Description",
      task_type: "Feature",
      priority: "Low",
      estimation: 10,
      project: project
    ).valid?
  end

  test "should have a title" do
    task = Task.new(
      start_date: Date.today,
      end_date: Date.today + 30,
      status: "Unstarted",
      description: "Test Description",
      task_type: "Test Type",
      estimation: 10
    )
    refute task.valid?
    assert_includes task.errors[:title], "can't be blank"
  end

  test "should have an end date" do
    task = Task.new(
      start_date: Date.today,
      status: "Unstarted",
      description: "Test Description",
      task_type: "Test Type",
      estimation: 10
    )
    refute task.valid?
    assert_includes task.errors[:end_date], "can't be blank"
  end

  test "should have a description" do
    task = Task.new(
      start_date: Date.today,
      end_date: Date.today + 30,
      status: "Unstarted",
      task_type: "Test Type",
      estimation: 10
    )
    refute task.valid?
    assert_includes task.errors[:description], "can't be blank"
  end

  test "start date should not be in the past" do
    task = Task.new(
      start_date: Date.today - 1,
      end_date: Date.today + 30,
      status: "Unstarted",
      description: "Test Description",
      task_type: "Test Type",
      estimation: 10
    )
    refute task.valid?
    assert_includes task.errors[:start_date], "can't be in the past"
  end

  test "end date should not be in the past" do
    task = Task.new(
      start_date: Date.today,
      end_date: Date.today - 1,
      status: "Unstarted",
      description: "Test Description",
      task_type: "Test Type",
      estimation: 10
    )
    refute task.valid?
    assert_includes task.errors[:end_date], "can't be in the past"
  end

  test "end date should be greater than start date" do
    task = Task.new(
      start_date: Date.today + 30,
      end_date: Date.today + 20,
      status: "Unstarted",
      description: "Test Description",
      task_type: "Test Type",
      estimation: 10
    )
    refute task.valid?
    assert_includes task.errors[:end_date], "can't be earlier than start date"
  end

  # Testing the associations
  test "should belong to a project" do
    assert_respond_to tasks(:task_one), :project
  end

  test "should have many developers" do
    assert_respond_to tasks(:task_one), :developers
  end

  test "should have many labels" do
    assert_respond_to tasks(:task_one), :labels
  end

  # Testing the scopes
  test "should return unstarted tasks" do
    assert_includes Task.unstarted, tasks(:task_one)
    refute_includes Task.unstarted, tasks(:task_two)
  end

  test "should return started tasks" do
    assert_includes Task.started, tasks(:task_two)
    refute_includes Task.started, tasks(:task_one)
  end

  test "should return finished tasks" do
    assert_includes Task.finished, tasks(:task_three)
    refute_includes Task.finished, tasks(:task_one)
  end

  test "should return feature tasks" do
    assert_includes Task.feature, tasks(:task_one)
    refute_includes Task.feature, tasks(:task_two)
  end

  test "should return chore tasks" do
    assert_includes Task.chore, tasks(:task_two)
    refute_includes Task.chore, tasks(:task_one)
  end

  test "should return bug tasks" do
    assert_includes Task.bug, tasks(:task_three)
    refute_includes Task.bug, tasks(:task_one)
  end

  test "should return release tasks" do
    assert_includes Task.release, tasks(:task_four)
    refute_includes Task.release, tasks(:task_one)
  end

  test "should return low priority tasks" do
    assert_includes Task.low, tasks(:task_one)
    refute_includes Task.low, tasks(:task_two)
  end

  test "should return medium priority tasks" do
    assert_includes Task.medium, tasks(:task_two)
    refute_includes Task.medium, tasks(:task_one)
  end

  test "should return high priority tasks" do
    assert_includes Task.high, tasks(:task_three)
    refute_includes Task.high, tasks(:task_one)
  end

  test "should return recent tasks" do
    assert_includes Task.recent, tasks(:task_one)
    refute_includes Task.recent, tasks(:task_four)
  end
end
