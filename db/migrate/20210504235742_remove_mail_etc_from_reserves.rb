class RemoveMailEtcFromReserves < ActiveRecord::Migration[6.1]
  def change
    remove_column :reserve_dates, :user_email, :string
    remove_column :reserve_dates, :start_transfer, :string
    remove_column :reserve_dates, :end_transfer, :string
  end
end
