class Course < ApplicationRecord
  validates :title, :short_description, :level, :language, presence: true
  validates :description, presence: true, length: { :minimum => 5}
  validates :price, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 2**32 }
  
  # attr_accessor :slug
  has_many :lessons, dependent: :destroy
  belongs_to :user
  has_many :enrollments
  has_rich_text :description

  extend FriendlyId
  friendly_id :title, use: [:slugged]
  
  include PublicActivity::Model
  tracked
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  

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
    self.enrollments.where(user_id: user.id).any?
  end

  def update_average_rate
    if enrollments
      self.update(average_rating: enrollments.average(:rating))
    end
  end

end
