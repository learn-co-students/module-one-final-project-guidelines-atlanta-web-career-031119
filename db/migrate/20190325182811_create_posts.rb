class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.integer :monster_id
      t.text :content
      t.timestamp 
    end 
  end
end
