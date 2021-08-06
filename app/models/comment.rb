class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  has_rich_text :content
  validates :content, presence: true
end
