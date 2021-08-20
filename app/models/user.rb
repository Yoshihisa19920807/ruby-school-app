class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
        # omniauth_providers indicates the authorization path?
         :trackable, :confirmable,:omniauthable , omniauth_providers: [:google_oauth2, :github, :facebook]

  has_many :courses, dependent: :nullify
  has_many :enrollments, dependent: :nullify
  has_many :user_lessons, dependent: :nullify
  has_many :comments, dependent: :nullify

  validate :must_have_a_role, on: :update

  extend FriendlyId
  friendly_id :email, use: :slugged

  after_create :assign_default_role

  def to_s
    email
  end

  def online?
    # 2.minutes.ago: current time - 2 minutes
    updated_at > 2.minutes.ago
  end

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

  def self.from_omniauth(access_token)

    p "___access_token"
    p access_token
    p "access_token.credentials.refresh_token"
    p access_token.credentials.refresh_token
    data = access_token.info
    p "data___"
    p data
    p data['name']
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0,20],
      )
    end

    user.provider = access_token['provider'],
    user.uid = access_token['uid'],
    user.name = data['name'],
    user.image = data.image,
    user.token = access_token.credentials['token'],
    user.expires = access_token.credentials.expires,
    user.expires_at = access_token.credentials['expires_at'],
    user.refresh_token = access_token.credentials.refresh_token,
    user.confirmed_at = Time.now #autoconfirm user from omniauth

    user
  end

  private

  def must_have_a_role
    # roles is equal to self.roles
    unless roles.any?
      errors.add(:roles, "must have at least one role")
    end
  end
  
end
