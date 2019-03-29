class AddDangerRatingToMonsters < ActiveRecord::Migration[5.0]
  def change
    add_column :monsters, :danger_rating, :integer
  end
end
