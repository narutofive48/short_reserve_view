class CreateBedtypes < ActiveRecord::Migration[6.1]
  def change
    create_table :bedtypes do |t|
      t.string :bed_type

      t.timestamps
    end
  end
end
