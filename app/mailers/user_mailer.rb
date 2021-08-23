class UserMailer < ApplicationMailer
  def new_user(user)
    @user = user
    # mailのtoは配列を指定できる
    mail(to: User.with_role(:admin).distinct.pluck(:email), subject: "Ruby Gems Bootcamp: #{@user.email} registred")
  end
end
