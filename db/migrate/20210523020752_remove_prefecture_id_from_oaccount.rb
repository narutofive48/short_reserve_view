class RemovePrefectureIdFromOaccount < ActiveRecord::Migration[6.1]
  def change
    remove_column :oaccounts, :office_prefecture_id
  end
end
