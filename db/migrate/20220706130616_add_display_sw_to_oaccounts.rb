class AddDisplaySwToOaccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :oaccounts, :display_sw, :integer
  end
end
