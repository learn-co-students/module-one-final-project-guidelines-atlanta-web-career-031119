class CreateMonsters < ActiveRecord::Migration[5.0]
  def change
    create_table :monsters do |t|
      t.string :name
      t.string :location
      t.integer :post_id
      t.timestamp
    end 
  end
end
