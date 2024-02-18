require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  # Testing the associations
  test "should belong to developer" do
    assert_respond_to Notification.new, :developer
  end

  # Testing the validations
  test "should not be created without developer" do
    notification = Notification.new(
      text: "Test"
    )
    refute notification.valid?
    assert_includes notification.errors[:developer], "must exist"
  end

  test "should not be created without text" do
    notification = Notification.new(
      developer: developers(:john_doe),
      read: false
    )
    refute notification.valid?
    assert_includes notification.errors[:text], "can't be blank"
  end

  test "should not be created without read" do
    notification = Notification.new(
      developer: developers(:john_doe),
      text: "Test"
    )
    refute notification.valid?
    assert_includes notification.errors[:read], "can't be blank"
  end

  test "should not be created with invalid read" do
    notification = Notification.new(
      developer: developers(:john_doe),
      text: "Test",
      read: nil
    )
    refute notification.valid?
    assert_includes notification.errors[:read], "#{notification.read} is not valid"
  end

  # test the scope
  test "should return all unread notifications" do
    assert_equal 1, Notification.unread.count
  end

  test "should return all read notifications" do
    assert_equal 1, Notification.read.count
  end
end
