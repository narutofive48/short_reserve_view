class AddRemoveToReserve < ActiveRecord::Migration[6.1]
  def change
    add_column :reserve_dates, :start_transfer_id, :integer
    add_column :reserve_dates, :end_transfer_id, :integer
  end
end
