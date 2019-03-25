class AddDescriptionToMonsters < ActiveRecord::Migration[5.0]
  def change
    add_column :monsters, :description, :text
    remove_column :monsters, :post_id
  end
end
