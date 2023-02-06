class RemovePastUseReserve < ActiveRecord::Migration[6.1]
  def change
    remove_column :reserve_dates, :past_use, :string
  end
end
