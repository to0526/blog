class Post < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(created_at: :desc) }
end
