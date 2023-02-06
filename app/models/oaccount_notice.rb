class OaccountNotice < ApplicationRecord
  include Noticable
  belongs_to :oaccount
end
