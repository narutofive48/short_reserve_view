class Contact
  include ActiveModel::Model
  attr_accessor :name, :mailaddress, :text
  def self.model_name
    ActiveModel::Name.new(self, nil, "Contact")
  end
  def send_mail
    ContactMailer.contact(name, mailaddress, text).deliver_now
  end
end
