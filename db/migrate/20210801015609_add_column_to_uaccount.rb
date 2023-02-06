class AddColumnToUaccount < ActiveRecord::Migration[6.1]
  def change
    add_column  :uaccounts,  :confirmation_token,  :string
    add_column  :uaccounts,  :confirmed_at,        :datetime
    add_column  :uaccounts,  :confirmation_sent_at,:datetime    
    add_column  :uaccounts,  :unconfirmed_email,   :string 
  end
end
