User.find_or_create_by!(email: ENV.fetch("BLOG_ADMIN_EMAIL", "admin@example.com")) do |user|
  user.password = ENV.fetch("BLOG_ADMIN_PASSWORD", "password")
  user.password_confirmation = ENV.fetch("BLOG_ADMIN_PASSWORD", "password")
end
