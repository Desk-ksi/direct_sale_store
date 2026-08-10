class CreatePostImages < ActiveRecord::Migration[8.1]
  def change
    create_table :post_images do |t|
      t.references :post, foreign_key: true, null: false
      t.string :post_image
      t.timestamps
    end
  end
end
