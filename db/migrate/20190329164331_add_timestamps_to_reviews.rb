class AddTimestampsToReviews < ActiveRecord::Migration[5.0]
  def change
    drop_table :reviews
  end

  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :event_id
      t.text    :content
      t.boolean :recommend
      t.timestamps
    end
  end  
end
