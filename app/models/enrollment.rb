class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course
  # user_idとcopurse_idの組み合わせが重複するレコードの作成を禁止
  validates :user_id, uniqueness: { scope: :course_id }
  validates :rating, presence: true, on: :update
  validates :review, presence: true, on: :update
  has_rich_text :review

  extend FriendlyId
  friendly_id :to_s, :use => [:slugged]

  def to_s
    p "user_id___"
    p user.slug
    user.to_s + " " + course.to_s
  end
end
