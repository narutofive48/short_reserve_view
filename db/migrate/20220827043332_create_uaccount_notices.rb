class CreateUaccountNotices < ActiveRecord::Migration[6.1]
  def change
    create_table :uaccount_notices do |t|
      t.references :uaccount, null: false, foreign_key: true
      t.datetime :begin_at, null: false
      t.datetime :end_at
      t.text :notice_text, null: false
      t.datetime :checked_at
      t.string :link_to

      t.timestamps
    end
  end
end
