class AddPasswordToOffices < ActiveRecord::Migration[6.1]
  def change
    add_column :offices, :password, :string
  end
end
