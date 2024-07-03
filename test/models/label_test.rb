require "test_helper"

class LabelTest < ActiveSupport::TestCase
  # testing the validations
  test "should not be created" do
    refute Label.new.valid?
  end

  test "should be created with valid attributes" do
    assert Label.new(name: "Test Label").valid?
  end

  test "should not be valid without name" do
    label = Label.new
    refute label.valid?
    assert_includes label.errors[:name], "can't be blank"
  end

  # testing the associations
  test "should have many tasks" do
    assert_respond_to Label.new, :tasks
  end

  # testing the scopes
  test "should return recent labels" do
    old_label = Label.create(
      name: "Old Label",
      created_at: 1.month.ago
    )
    new_label = Label.create(
      name: "New Label",
      created_at: 1.week.ago
    )
    assert_includes Label.recent, new_label
    refute_includes Label.recent, old_label
  end
end
