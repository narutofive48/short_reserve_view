class CreateOaccountNotices < ActiveRecord::Migration[6.1]
  def change
    create_table :oaccount_notices do |t|
      t.references :oaccount, null: false, foreign_key: true
      t.datetime :begin_at, null: false
      t.datetime :end_at
      t.text :notice_text, null: false
      t.datetime :checked_at
      t.string :link_to

      t.timestamps
    end
  end
end
