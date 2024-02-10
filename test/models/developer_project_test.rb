require "test_helper"

class DeveloperProjectTest < ActiveSupport::TestCase
  # Testing the associations
  test "should belong to developer" do
    assert_respond_to DeveloperProject.new, :developer
  end

  test "should belong to project" do
    assert_respond_to DeveloperProject.new, :project
  end

  # Testing the validations
  test "should not be created without developer" do
    developer_project = DeveloperProject.new(project: projects(:project_one))
    refute developer_project.valid?
    assert_includes developer_project.errors[:developer], "must exist"
  end

  test "should not be created without project" do
    developer_project = DeveloperProject.new(developer: developers(:john_doe))
    refute developer_project.valid?
    assert_includes developer_project.errors[:project], "must exist"
  end

  test "should not be created without email" do
    developer_project = DeveloperProject.new(
      developer: developers(:john_doe),
      project: projects(:project_one),
      status: "Started"
    )
    refute developer_project.valid?
    assert_includes developer_project.errors[:email], "can't be blank"
  end

  test "should not be created without status" do
    developer_project = DeveloperProject.new(
      developer: developers(:john_doe),
      project: projects(:project_one),
      email: "test@example.com"
    )
    refute developer_project.valid?
    assert_includes developer_project.errors[:status], "can't be blank"
  end
end
