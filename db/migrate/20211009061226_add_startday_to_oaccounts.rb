class AddStartdayToOaccounts < ActiveRecord::Migration[6.1]
  def change
    add_column  :oaccounts, :startday, :date
  end
end
