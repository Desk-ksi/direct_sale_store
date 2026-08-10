class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.references :shop, null:false, foreign_key: true
      t.boolean :sold_out, default: false, null: false
      t.string :merchandise
      t.string :top_merchandise
      t.text :comment
      t.string :schedule
      t.integer :number_view
      t.timestamps
    end
  end
end
