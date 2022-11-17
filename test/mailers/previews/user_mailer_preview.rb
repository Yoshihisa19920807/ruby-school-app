# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def new_user
    UserMailer.with(user: User.last).new_user(User.last)
  end
end
