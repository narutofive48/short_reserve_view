class AddPastUseIdReserve < ActiveRecord::Migration[6.1]
  def change
    add_column :reserve_dates, :past_use_id, :integer
  end
end
