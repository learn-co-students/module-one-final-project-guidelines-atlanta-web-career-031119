class CreateMovies < ActiveRecord::Migration[5.0]
  def change
    create_table :movies do |t|
      t.string  :title
      t.string  :release_date
      t.float   :rating
      t.string  :runtime
      t.text    :plot
    end
  end
end
