class ContactMailer < ApplicationMailer
  default to: 'narutofive48@gmail.com'
  def contact(name,mailaddress,text)
    @name = name
    @mailaddress = mailaddress
    @text = text
    mail(from: mailaddress, subject: "【Picot】にお問い合わせがありました")
  end
end
