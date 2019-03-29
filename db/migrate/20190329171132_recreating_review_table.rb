class RecreatingReviewTable < ActiveRecord::Migration[5.0]
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
