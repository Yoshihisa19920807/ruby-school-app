class Course < ApplicationRecord
  validates :title, :short_description, :level, :language, :price, presence: true
  validates :description, presence: true, length: { :minimum => 5}
  # attr_accessor :slug

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

  belongs_to :user
  has_rich_text :description
end
