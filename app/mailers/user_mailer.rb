class UserMailer < ActionMailer::Base
  default :from => "noreply@physolymp.ru"

  def activation_needed_email(user)
    @user = user
    @url  = "http://physolymp.ru/users/#{user.activation_token}/activate"
    mail(:to => user.email,
         :subject => "Подтверждение регистрации")
  end

  def activation_success_email(user)
    @user = user
    @url  = "http://physolymp.ru/login"
    mail(:to => user.email,
         :subject => "Your account is now activated")
  end
end
