class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    @url = "http:// localhost:3000/login"
    mail to: @user.email, subject: t("account_activation")
  end

  def password_reset
    @greeting = "Hi"
    mail to: "to@example.org"
  end
end
