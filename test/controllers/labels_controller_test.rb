require "test_helper"

class LabelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @label = labels(:frontend)
    @label_params = {
      name: "Backend"
    }
  end

  test "should get index" do
    get labels_url
    assert_response :success
  end

  test "should get new" do
    get new_label_url
    assert_response :success
  end

  test "should create label with valid params" do
    assert_difference("Label.count") do
      post labels_url, params: {label: @label_params}
    end

    assert_redirected_to labels_url
  end

  test "should not create label with invalid params" do
    assert_no_difference("Label.count") do
      post labels_url, params: {label: @label_params.merge(name: nil)}
    end

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_label_url(@label)
    assert_response :success
  end

  test "should update label" do
    patch label_url(@label), params: {label: @label_params}
    assert_redirected_to labels_url
  end

  test "should destroy label" do
    assert_difference("Label.count", -1) do
      delete label_url(@label)
    end

    assert_redirected_to labels_url
  end
end
