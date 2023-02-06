class AddOfficeNumberToOaccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :oaccounts, :office_num, :string
  end
end
