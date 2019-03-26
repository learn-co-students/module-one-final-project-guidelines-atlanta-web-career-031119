class CreateMovieWatchlist < ActiveRecord::Migration[5.0]
  def change
    create_table :movie_watchlists do |t|
      t.integer   :user_id
      t.integer   :movie_id
      t.boolean   :watched
      t.float     :rating
      t.text      :review
    end
  end
end
