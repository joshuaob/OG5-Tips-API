class OtpMailer < ApplicationMailer
  default from: 'hello@og5.tips'

  def send_otp(account:, code:)
    @code = code 
    mail(to: account.email, subject: 'Your One Time Passcode')
  end
end
