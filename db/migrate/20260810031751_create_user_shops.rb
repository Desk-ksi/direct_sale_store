class CreateUserShops < ActiveRecord::Migration[8.1]
  def change
    create_table :user_shops do |t|
      t.references :user, foreign_key: true, null: false
      t.references :shop, foreign_key: true, null: false
      t.timestamps
    end
    add_index :user_shops, [:user_id, :shop_id], unique: true
  end
end
