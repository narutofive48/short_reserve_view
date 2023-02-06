class AddPhoneToOaccount < ActiveRecord::Migration[6.1]
  def change
    add_column :oaccounts, :office_phone, :string, null: false
  end
end
