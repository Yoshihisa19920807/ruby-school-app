class Enrollment < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :course, counter_cache: true
  # user_idとcopurse_idの組み合わせが重複するレコードの作成を禁止
  validates :user_id, uniqueness: { scope: :course_id }
  validates :rating, presence: true, on: :update
  validates :review, presence: true, on: :update
  has_rich_text :review
  scope :reviewed, -> { where.not(rating: nil)}
  scope :review_pending, -> { where(rating: nil)}

  extend FriendlyId
  friendly_id :to_s, :use => [:slugged]

  after_destroy :call_update_average_rate
  after_update :call_update_average_rate

  def to_s
    # p "user_id___"
    # p user.slug
    user.to_s + " " + course.to_s
  end

  def call_update_average_rate
    course.update_average_rate
  end

end
