class CreateReserveDates < ActiveRecord::Migration[6.1]
  def change
    create_table :reserve_dates do |t|
      t.string :user_email
      t.integer :office_id
      t.date :start_date
      t.string :start_transfer
      t.date :end_date
      t.string :end_transfer
      t.string :past_use
      t.integer :entry_flg
      t.text :remark

      t.timestamps
    end
  end
end
