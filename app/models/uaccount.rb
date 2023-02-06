class Uaccount < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  validates :email,{presence: true, uniqueness:true}
  enum commerce: { deny_send_mail: 0, allow_send_mail: 1}
  has_many :favorites, dependent: :destroy
  has_many :matters, dependent: :destroy
end
