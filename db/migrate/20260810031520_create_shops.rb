class CreateShops < ActiveRecord::Migration[8.1]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.string :shop_image, null: false
      t.text :kodawari
      t.string :price
      t.string :season
      t.string :business_hours
      t.string :timing
      t.integer :like_count
      t.timestamps
    end
  end
end
