class Course < ApplicationRecord

  # attr_accessor :slug
  has_many :lessons, dependent: :destroy
  has_many :user_lessons, through: :lessons

  has_many :course_tags
  has_many :tags, through: :course_tags

  # can't delete if there's any student
  has_many :enrollments, dependent: :restrict_with_error

  belongs_to :user, counter_cache: true

  has_rich_text :description
  has_one_attached :avatar

  accepts_nested_attributes_for :tags, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :course_tags, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :lessons, reject_if: :all_blank, allow_destroy: true

  extend FriendlyId
  friendly_id :title, use: [:slugged]

  include PublicActivity::Model
  tracked
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  scope :latest, -> { all.order(created_at: :desc).limit(3) }
  scope :popular, -> { all.order(enrollments_count: :desc).limit(3) }
  # scope :top_rated, -> { all.order(enrollments_count).limit(3) }
  scope :top_rated,-> { all.order(average_rating: :desc).limit(3) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }
  scope :purchased, -> (user) {includes(:enrollments).where(enrollments: {user: user})} 

  # validates :avatar, attached: true,
  validates :avatar,
    content_type: ['image/png', 'image/jpg', 'image/jpeg'],
    size: { less_than: 100.megabytes , message: 'File size must be less than 100 mb' }
  validates :level, :language, presence: true
  validates :title, uniqueness: true, presence: true, length: {maximum: 70}
  validates :description, presence: true, length: { :minimum => 5}
  validates :short_description, presence: true, length: {maximum: 300}
  validates :price, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 2**32 }

  ## assign random id instead
  # friendly_id :generated_slug, use: :slugged
  # def generated_slug
  #   require 'securerandom'
  #   @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  # end

  # languages = ["English", "Russian", "Japanese"]

  def self.languages
    ["English", "Russian", "Japanese"]
  end

  # LANGUAGES = [:"English", :"Russian", :"Polish", :"Spanish"]
  # def self.languages
  #   LANGUAGES.map { |language| [language, language] }
  # end

  def self.levels
    ["Beginner", "Intermidiate", "Advanced"]
  end

  def to_s
    title
  end

  def bought? user
    self.enrollments.where(user: user).any?
  end

  def update_average_rate
    # if enrollments
    #   self.update(average_rating: enrollments.average(:rating) || 0)
    # end
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0)
    end
  end

  def progress user
    if lessons_count !=0
      user_lessons.where(user: user).count.to_f/lessons_count.to_f*100
    else
      0.0
    end
  end

  def update_course_income
    p "____self.enrollments"
    p self.enrollments
    p "self.enrollments.map(&:price)"
    p self.enrollments.map(&:price)
    self.update(income: self.enrollments.map(&:price).sum)
    user.update_user_income
  end

end
