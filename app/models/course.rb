class Course < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true, length: { :minimum => 5}
  # attr_accessor :slug
  
  extend FriendlyId
  friendly_id :title, use: [:slugged]
  
  ## assign random id instead
  # friendly_id :generated_slug, use: :slugged
  # def generated_slug
  #   require 'securerandom'
  #   @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  # end
  
  
  def to_s
    title
  end
  
  belongs_to :user 
  
  has_rich_text :description
end
