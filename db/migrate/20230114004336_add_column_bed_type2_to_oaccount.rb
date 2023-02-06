class AddColumnBedType2ToOaccount < ActiveRecord::Migration[6.1]
  def change
    add_column :oaccounts, :bed_type2_id, :integer
  end
end
