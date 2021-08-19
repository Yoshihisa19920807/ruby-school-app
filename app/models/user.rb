class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable,:omniauthable , omniauth_providers: [:google_oauth2, :github]

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

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      p "unless_user"  
      user = User.create(
        provider: access_token['provider'],
        uid: access_token['uid'],
        email: data['email'],
        password: Devise.friendly_token[0,20],
        name: data['name'],
        image: data.image,
        token: access_token.credentials['token'],
        expires: access_token.credentials.expires,
        expires_at: access_token.credentials['expires_at'],
        refresh_token: access_token.credentials.refresh_token,
        confirmed_at: Time.now #autoconfirm user from omniauth
      )
    else
      user.update(
        name: access_token.info.name,
        image: access_token.info.image,
        provider: access_token.provider,
        uid: access_token.uid,
        token: access_token.credentials.token,
        expires_at: access_token.credentials.expires_at,
        expires: access_token.credentials.expires,
        refresh_token: access_token.credentials.refresh_token
      )
    end
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
