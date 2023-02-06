class AddNameToOaccount < ActiveRecord::Migration[6.1]
  def change
    add_column :oaccounts, :office_name, :string
    add_column :oaccounts, :office_prefecture_id, :integer
    add_column :oaccounts, :office_city_id, :integer
    add_column :oaccounts, :office_url, :string
    add_column :oaccounts, :office_bed_count, :integer
    add_column :oaccounts, :office_apear, :text
    add_column :oaccounts, :office_image, :string
  end
end
