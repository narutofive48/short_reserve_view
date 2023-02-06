class AddUserNameToReserveDate < ActiveRecord::Migration[6.1]
  def change
    add_column :reserve_dates, :user_name, :string
    add_column :reserve_dates, :user_phone, :string
    change_column_null :reserve_dates, :user_id, true, nil
  end
end
