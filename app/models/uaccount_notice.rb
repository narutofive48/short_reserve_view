class UaccountNotice < ApplicationRecord
  include Noticable
  belongs_to :uaccount
end
