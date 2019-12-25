class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :location
      t.string :venue
      t.string :genre
      t.string :date
      t.string :start_time
      
    end
  end
end
