class AddCommerceToUaccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :uaccounts, :commerce, :integer
  end
end
