class AddPrefectureidToCities < ActiveRecord::Migration[6.1]
  def change
    add_reference :cities, :prefecture, null: false, foreign_key: true
  end
end
