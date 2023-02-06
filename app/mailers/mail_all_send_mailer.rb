class MailAllSendMailer < ApplicationMailer
  default from: 'admin@picot.jp'
  def send_uaccount(uaccount, text, subject)
    @uaccount = uaccount
    @text = text
    mail(to: uaccount.email, subject: subject)
  end
end
