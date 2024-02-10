require "test_helper"

class TasksLabelTest < ActiveSupport::TestCase
  # Testing the associations
  test "should belong to task" do
    assert_respond_to TasksLabel.new, :task
  end

  test "should belong to label" do
    assert_respond_to TasksLabel.new, :label
  end

  # Testing the validations
  test "should not be created without task" do
    tasks_label = TasksLabel.new(label: labels(:frontend))
    refute tasks_label.valid?
    assert_includes tasks_label.errors[:task], "must exist"
  end

  test "should not be created without label" do
    tasks_label = TasksLabel.new(task: tasks(:task_one))
    refute tasks_label.valid?
    assert_includes tasks_label.errors[:label], "must exist"
  end
end
