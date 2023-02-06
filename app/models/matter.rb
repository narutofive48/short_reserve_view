class Matter < ApplicationRecord
  enum end_reception_flg: { reception: 0, end_reception: 1}
  belongs_to :uaccount, optional: true
end
