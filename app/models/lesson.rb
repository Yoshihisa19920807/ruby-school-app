class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  # has_many :user_lessons, dependent: :destroy
  # has_many :user_lessons, dependent: :destroy
  has_many :user_lessons, dependent: :destroy
  has_many :comments, dependent: :nullify
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates :content, :course, presence: true
  validates :title, presence: true, uniqueness: true, length: { maximum: 70 }

  has_rich_text :content
  has_one_attached :video
  validates :video,
            #  presence: true,
            content_type: ['video/mp4'],
            size: {
              less_than: 50.megabytes,
              message: 'File size must be less than 50 mb',
            }

  has_one_attached :video_thumbnail
  validates :video_thumbnail,
            # presence: true,
            size: {
              less_than: 1.megabytes,
              message: 'File size must be less than 500 kb',
            }

  cattr_accessor :current_user

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  include RankedModel
  ranks :row_order, with_same: :course_id

  def to_s
    title
  end

  def prev
    course.lessons.where('row_order < ?', row_order).order(:row_order).last
  end

  def next
    course.lessons.where('row_order > ?', row_order).order(:row_order).first
  end

  def view_lesson
    # UserLesson.create(user: self.current_user, lesson: self)
    user_lessons = UserLesson.where(user: self.current_user, lesson: self)
    if user_lessons.any?
      user_lessons.first.increment!(:impressions)
    else
      UserLesson.create(user: self.current_user, lesson: self)
    end
  end

  def viewed?(user)
    UserLesson.where(user: self.current_user, lesson: self).present?
  end
end
