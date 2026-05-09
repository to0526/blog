require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "GET /login renders login form" do
    get login_path
    assert_response :ok
    assert_select "form"
  end

  test "POST /login with valid credentials logs in and redirects to root" do
    post login_path, params: { email: users(:admin).email, password: "password" }
    assert_redirected_to root_path
    assert_equal users(:admin).id, session[:user_id]
  end

  test "POST /login with invalid password shows error" do
    post login_path, params: { email: users(:admin).email, password: "wrong" }
    assert_response :unprocessable_entity
    assert_select ".flash-alert"
    assert_nil session[:user_id]
  end

  test "POST /login with unknown email shows error" do
    post login_path, params: { email: "nobody@example.com", password: "password" }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "DELETE /logout clears session and redirects to login" do
    post login_path, params: { email: users(:admin).email, password: "password" }
    delete logout_path
    assert_redirected_to login_path
    assert_nil session[:user_id]
  end
end
