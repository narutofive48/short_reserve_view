class AddFaxNumToOaccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :oaccounts, :fax_num, :string
  end
end
