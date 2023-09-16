require "test_helper"

class DeveloperTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "developer should not be created" do
    refute Developer.new.valid?
  end

  test "developer should be created" do
    assert Developer.new(name: "Mario", lastname: "Rossi", email: "mario.rossi@test.com", password: "password").valid?
  end

end
