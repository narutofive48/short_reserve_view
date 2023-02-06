class AddColumnMaxReservationMonthsToOaccount < ActiveRecord::Migration[6.1]
  def change
    add_column :oaccounts, :max_reservation_months, :integer, null: false, default: 3
  end
end
