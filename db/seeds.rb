User.destroy_all
Movie.destroy_all
MovieWatchlist.destroy_all

princeton = User.create(name: "Princeton")
abdul = User.create(name: "Abdul")
batman = Movie.create(title: "Batman", release_date: "Sometime in 1990", plot: "Batman catches criminals! Pow!", rating: 10.0, runtime: "143 minutes")
superman = Movie.create(title: "Superman", release_date: "Sometime in the 80's", plot: "Hero's only weakness is a green rock... how boring. ZZzzz...", runtime: "too long...", rating: 3.5)

