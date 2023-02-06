class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :uaccount, null: false, foreign_key: true
      t.references :oaccount, null: false, foreign_key: true
      t.integer :favorite_flg, default: 0
      t.timestamps
    end
  end
end
