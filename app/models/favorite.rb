class Favorite < ApplicationRecord
  belongs_to :uaccount
  belongs_to :oaccount
  enum favorite_flg: { no_favorite_flg: 0, favorite_flg: 1 }

  def self.oaccount_ids(uaccount_id)
    where(uaccount_id: uaccount_id).pluck(:oaccount_id)
  end
end
