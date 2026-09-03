class AddPrefectureAndMunicipalityToShops < ActiveRecord::Migration[8.1]
  def change
    add_column :shops, :prefecture, :string, default: "", null: false
    add_column :shops, :municipality, :string, default: "", null: false
  end
end
