class AddColumnPaidUserToOaccount < ActiveRecord::Migration[6.1]
  def change
    add_column :oaccounts, :paid_oaccount, :integer, null: false, default: 0
  end
end
