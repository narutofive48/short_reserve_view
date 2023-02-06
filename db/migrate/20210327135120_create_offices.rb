class CreateOffices < ActiveRecord::Migration[6.1]
  def change
    create_table :offices do |t|
      t.integer :office_id
      t.string :office_name
      t.integer :office_prefecture_id
      t.integer :office_city_id
      t.string :office_url
      t.integer :office_bed_count
      t.string :office_email
      t.text :office_apear
      t.string :office_image

      t.timestamps
    end
  end
end
