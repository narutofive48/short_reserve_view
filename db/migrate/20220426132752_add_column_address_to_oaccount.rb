class AddColumnAddressToOaccount < ActiveRecord::Migration[6.1]
  def change
    add_column :oaccounts, :address, :string
    add_column :oaccounts, :trance_area, :string
    add_column :oaccounts, :medical_practice, :string
    add_column :oaccounts, :display_sort, :integer
  end
end
