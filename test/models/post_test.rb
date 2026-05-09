require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "valid with title and body" do
    post = Post.new(title: "タイトル", body: "本文")
    assert post.valid?
  end

  test "invalid without title" do
    post = Post.new(body: "本文")
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "invalid without body" do
    post = Post.new(title: "タイトル")
    assert_not post.valid?
    assert_includes post.errors[:body], "can't be blank"
  end

  test "published scope returns only published posts" do
    published = Post.published
    assert_includes published, posts(:published_post)
    assert_not_includes published, posts(:draft_post)
  end

  test "recent scope orders by created_at desc" do
    older = Post.create!(title: "古い記事", body: "本文", created_at: 2.days.ago)
    newer = Post.create!(title: "新しい記事", body: "本文", created_at: 1.day.ago)
    ids = Post.recent.pluck(:id)
    assert ids.index(newer.id) < ids.index(older.id)
  end

  test "default published is false" do
    post = Post.new(title: "タイトル", body: "本文")
    assert_equal false, post.published?
  end
end
