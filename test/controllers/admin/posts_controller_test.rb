require "test_helper"

class Admin::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as_admin
  end

  # --- new ---
  test "GET /admin/posts/new renders form" do
    get new_admin_post_path
    assert_response :ok
    assert_select "form"
  end

  # --- create ---
  test "POST /admin/posts creates post and redirects to show" do
    assert_difference "Post.count" do
      post admin_posts_path, params: { post: { title: "新記事", body: "内容", published: false } }
    end
    assert_redirected_to post_path(Post.last)
  end

  test "POST /admin/posts with blank title re-renders form" do
    assert_no_difference "Post.count" do
      post admin_posts_path, params: { post: { title: "", body: "内容" } }
    end
    assert_response :unprocessable_entity
    assert_select ".error-messages"
  end

  # --- edit ---
  test "GET /admin/posts/:id/edit renders form with existing data" do
    get edit_admin_post_path(posts(:published_post))
    assert_response :ok
    assert_select "input[value=?]", posts(:published_post).title
  end

  # --- update ---
  test "PATCH /admin/posts/:id updates post and redirects to show" do
    patch admin_post_path(posts(:published_post)), params: {
      post: { title: "更新タイトル", body: posts(:published_post).body, published: true }
    }
    assert_redirected_to post_path(posts(:published_post))
    assert_equal "更新タイトル", posts(:published_post).reload.title
  end

  test "PATCH /admin/posts/:id with blank title re-renders form" do
    patch admin_post_path(posts(:published_post)), params: {
      post: { title: "", body: posts(:published_post).body }
    }
    assert_response :unprocessable_entity
    assert_select ".error-messages"
  end

  # --- destroy ---
  test "DELETE /admin/posts/:id deletes post and redirects to root" do
    assert_difference "Post.count", -1 do
      delete admin_post_path(posts(:published_post))
    end
    assert_redirected_to root_path
  end

  # --- 未ログイン時のリダイレクト ---
  test "guest cannot access new post form" do
    delete logout_path
    get new_admin_post_path
    assert_redirected_to login_path
  end

  test "guest cannot create post" do
    delete logout_path
    assert_no_difference "Post.count" do
      post admin_posts_path, params: { post: { title: "不正", body: "本文" } }
    end
    assert_redirected_to login_path
  end

  private

  def login_as_admin
    post login_path, params: { email: users(:admin).email, password: "password" }
  end
end
