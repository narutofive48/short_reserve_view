class CreateReserveCounts < ActiveRecord::Migration[6.1]
  def change
    create_table :reserve_counts do |t|
      t.references :oaccount
      t.date :date, null: false
      t.integer :last_count, null: false
      t.timestamps
    end
    add_index :reserve_counts, [:oaccount_id, :date], unique:true
  end
end
