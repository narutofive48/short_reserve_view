class AddReserveCodeToReserveDatas < ActiveRecord::Migration[6.1]
  def change
    add_column :reserve_dates, :reserve_code, :string, null: false
    add_index :reserve_dates, :reserve_code, unique: true
  end
end
