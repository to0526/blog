require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  # --- index ---
  test "GET / shows only published posts when not logged in" do
    get root_path
    assert_response :ok
    assert_select "a", text: posts(:published_post).title
    assert_select "a", text: posts(:draft_post).title, count: 0
  end

  test "GET / shows all posts when logged in" do
    login_as_admin
    get root_path
    assert_response :ok
    assert_select "a[href=?]", post_path(posts(:published_post))
    assert_select "a[href=?]", post_path(posts(:draft_post))
  end

  # --- show ---
  test "GET /posts/:id shows published post to guest" do
    get post_path(posts(:published_post))
    assert_response :ok
    assert_select "h1", text: /#{posts(:published_post).title}/
  end

  test "GET /posts/:id redirects guest away from draft post" do
    get post_path(posts(:draft_post))
    assert_redirected_to root_path
  end

  test "GET /posts/:id shows draft post to logged-in user" do
    login_as_admin
    get post_path(posts(:draft_post))
    assert_response :ok
  end

  test "GET /posts/:id shows edit and delete links when logged in" do
    login_as_admin
    get post_path(posts(:published_post))
    assert_select "a[href=?]", edit_admin_post_path(posts(:published_post))
  end

  test "GET /posts/:id hides edit links when not logged in" do
    get post_path(posts(:published_post))
    assert_select "a[href=?]", edit_admin_post_path(posts(:published_post)), count: 0
  end

  private

  def login_as_admin
    post login_path, params: { email: users(:admin).email, password: "password" }
  end
end
