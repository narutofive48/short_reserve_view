class CreateMatters < ActiveRecord::Migration[6.1]
  def change
    create_table :matters do |t|
      t.references :uaccount, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.text :remark
      t.string :end_reception_flg
      t.timestamps
    end
  end
end
