require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "User's email is unique" do
    user1 = User.new(name: "John", email: "john@test.com", password: "password")
    user1.save
    user2 = User.new(name: "John Two", email: "john@test.com", password: "password")
    assert_not user2.valid?, "User with duplicate email was valid"
  end

  test "User's did not provide a password" do
    user1 = User.new(name: "John", email: "skbidi@bruh.com", password: "password")
    user1.save
    user2 = User.new(name: "John Two", email: "skibidhruh@bruh.com", password: "")
    assert_not user2.valid?, "User does not have a password"
  end
end