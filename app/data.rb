require 'rest-client'
require 'json'
require 'pry'


url = "https://app.ticketmaster.com/discovery/v2/events.json?size=50&apikey=7elxdku9GGG5k8j0Xm8KWdANDgecHMV0&countryCode=US&stateCode=GA"
response = RestClient.get(url)
data = JSON.parse(response.body)

binding.pry

File.write('./raw_data.rb', data)
