class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  has_many :user_lessons
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

    p "current_user"
    p current_user
    p self
    UserLesson.create!(user: self.current_user, lesson: self)
  end
end
