class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  # has_many :user_lessons, dependent: :destroy
  # has_many :user_lessons, dependent: :destroy
  has_many :user_lessons, dependent: :destroy
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates :title, :content, :course, presence: true
  
  has_rich_text :content

  cattr_accessor :current_user
  
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  include RankedModel
  ranks :row_order, with_same: :course_id

  def to_s
    title
  end

  def prev
    course.lessons.where("row_order < ?", row_order).order(:row_order).last
  end

  def next
    course.lessons.where("row_order > ?", row_order).order(:row_order).first
  end

  def view_lesson
    # UserLesson.create(user: self.current_user, lesson: self)
    user_lessons = UserLesson.where(user: self.current_user, lesson: self)
    if user_lessons.any?
      user_lessons.first.increment!(:impressions)
      p "____user_lessons.first"
      p user_lessons.first
    else
      UserLesson.create(user: self.current_user, lesson: self)
    end
  end

  def viewed? user
    UserLesson.where(user: self.current_user, lesson: self).present?
  end
end
