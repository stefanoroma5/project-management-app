require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @notification = notifications(:notification_one)
    @developer = developers(:john_doe)
    sign_in @developer
  end

  test "should get index" do
    get notifications_url
    assert_response :success
  end

  test "should update notification" do
    patch notification_url(@notification), params: {notification: {text: "Updated Notification", read: true}}
    assert_redirected_to notifications_url(@notifications)
    @notification.reload
    assert_equal "Updated Notification", @notification.text
    assert_equal true, @notification.read
  end
end
