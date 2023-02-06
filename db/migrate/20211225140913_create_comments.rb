class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :uaccount, null: true
      t.references :oaccount, null: true
      t.integer :sender_flg, null: false
      t.references :reserve_date, null: false
      t.datetime :uaccount_read_at, null: true, default: nil
      t.datetime :oaccount_read_at, null: true, default: nil
      t.datetime :deleted_at, null: true, default: nil
      t.text :comment, null: false

      t.timestamps
    end
  end
end
