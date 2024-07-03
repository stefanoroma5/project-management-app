require "test_helper"

class DeveloperTaskTest < ActiveSupport::TestCase
  # Testing the associations
  test "should belong to developer" do
    assert_respond_to DeveloperTask.new, :developer
  end

  test "should belong to task" do
    assert_respond_to DeveloperTask.new, :task
  end

  # Testing the validations
  test "should not be created without developer" do
    developer_task = DeveloperTask.new(task: tasks(:task_one))
    refute developer_task.valid?
    assert_includes developer_task.errors[:developer], "must exist"
  end

  test "should not be created without task" do
    developer_task = DeveloperTask.new(developer: developers(:john_doe))
    refute developer_task.valid?
    assert_includes developer_task.errors[:task], "must exist"
  end
end
