require 'rest-client'
require 'json'
require 'pry'
# tmdb api key: 84183c2fcf1dbb47fba4426356bb766c
# omdb api key: 92d4118f

searching = ''

while searching.downcase != "quit"
    puts "Enter in a movie to look for:"
    searching = gets.chomp
    movie_info = JSON.parse(RestClient.get("http://www.omdbapi.com/?t=#{searching}&apikey=92d4118f&"))  # General search that looks for movies with name -  movie_info = JSON.parse(RestClient.get("http://www.omdbapi.com/?s=#{searching}&apikey=92d4118f&"))
  # Search for first closest title match -  movie_info = JSON.parse(RestClient.get("http://www.omdbapi.com/?t=#{searching}&apikey=92d4118f&"))
  # Search for year -  movie_info = JSON.parse(RestClient.get("http://www.omdbapi.com/?y=#{searching}&apikey=92d4118f&"))

    puts movie_info
    binding.pry
end
    ## movies = JSON.parse(response)['Search']
    ## movies.first(10).each do |movie|
    ##   display_movie(movie)
    ## end