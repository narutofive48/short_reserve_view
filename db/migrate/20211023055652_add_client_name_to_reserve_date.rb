class AddClientNameToReserveDate < ActiveRecord::Migration[6.1]
  def change
    add_column :reserve_dates, :client_name, :string
  end
end
