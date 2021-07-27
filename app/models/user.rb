class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  has_many :courses

  def to_s
    email
  end

  def online?
    # 2.minutes.ago: current time - 2 minutes
    updated_at > 2.minutes.ago
  end

  extend FriendlyId
  friendly_id :email, use: :slugged

  after_create :assign_default_role

  def assign_default_role
    # if this is the first user
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher) #if you want any user to be able to create own courses
    end
  end
  
  validate :must_have_a_role, on: :update

  private

  def must_have_a_role
    # roles is equal to self.roles
    unless roles.any?
      errors.add(:roles, "must have at least one role")
    end
  end
  
end
