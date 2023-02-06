class CreatePasts < ActiveRecord::Migration[6.1]
  def change
    create_table :pasts do |t|
      t.string :past_use

      t.timestamps
    end
  end
end
