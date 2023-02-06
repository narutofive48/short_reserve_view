class AddColumnDisableBedCountToReserveCount < ActiveRecord::Migration[6.1]
  def change
    add_column :reserve_counts, :disable_bed_count, :integer, default: 0, null: false
  end
end
