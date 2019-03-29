class AddTimestampsToReviews < ActiveRecord::Migration[5.0]
  def change
    drop_table :reviews
  end  
end
