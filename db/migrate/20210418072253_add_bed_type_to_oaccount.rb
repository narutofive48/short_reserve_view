class AddBedTypeToOaccount < ActiveRecord::Migration[6.1]
  def change
    add_column :oaccounts, :office_bed_type, :integer
  end
end
