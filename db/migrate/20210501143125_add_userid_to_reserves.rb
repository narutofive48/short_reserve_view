class AddUseridToReserves < ActiveRecord::Migration[6.1]
  def change
    add_column :reserve_dates, :user_id, :integer
  end
end
