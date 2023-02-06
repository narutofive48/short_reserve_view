class AddNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :uaccounts, :user_name, :string
    add_column :uaccounts, :user_office, :string
    add_column :uaccounts, :user_phone, :string
  end
end
