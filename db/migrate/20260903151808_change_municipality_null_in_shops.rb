class ChangeMunicipalityNullInShops < ActiveRecord::Migration[8.1]
  def change
    change_column_null :shops, :municipality, true
  end
end
