class CreateUserPostLikes < ActiveRecord::Migration[8.1]
  def change
    create_table :user_post_likes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :post, foreign_key: true, null: false
      t.timestamps
    end
    add_index :user_post_likes, [:user_id, :post_id], unique: true
  end
end
