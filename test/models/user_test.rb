require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid with email and password" do
    user = User.new(email: "new@example.com", password: "password")
    assert user.valid?
  end

  test "invalid without email" do
    user = User.new(password: "password")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "invalid with duplicate email" do
    user = User.new(email: users(:admin).email, password: "password")
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "authenticate returns user with correct password" do
    user = users(:admin)
    assert user.authenticate("password")
  end

  test "authenticate returns false with wrong password" do
    user = users(:admin)
    assert_not user.authenticate("wrong")
  end
end
