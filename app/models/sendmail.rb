class Sendmail
  include ActiveModel::Model
  attr_accessor :text, :subject
  def self.model_name
    ActiveModel::Name.new(self, nil, "Sendmail")
  end
  def send_mail
    uaccounts.each do |uaccount|
      MailAllSendMailer.sendmail(uaccount, text, subject).deliver_now
    end
  end
  private
    def uaccounts
      Uaccount.allow_send_mail
    end
end
