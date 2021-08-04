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
  
  def to_s
    title
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
end
