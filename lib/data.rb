require 'rest-client'
require 'json'
require 'pry'
#require_relative './models/event'


url = "https://app.ticketmaster.com/discovery/v2/events.json?size=50&apikey=7elxdku9GGG5k8j0Xm8KWdANDgecHMV0&countryCode=US&stateCode=GA"
response = RestClient.get(url)
data = JSON.parse(response.body)


# File.write('./raw_data.rb', data)

# File.write('./raw_data.rb', data)

#name = data["_embedded"]["events"][0]["name"]
#location(city) = data["_embedded"]["events"][0]["_embedded"]["venues"][0]["city"]["name"]
#venue(name) = data["_embedded"]["events"][0]["_embedded"]["venues"][0]["name"]
#genre = data["_embedded"]["events"][0]["classifications"][0]["genre"]["name"]
#date = data["_embedded"]["events"][0]["dates"]["start"]["localDate"]
#start_time = data["_embedded"]["events"][0]["dates"]["start"]["localTime"]
#price = data["_embedded"]["events"][11]["priceRanges"][0]["min"]

# File.open('./test.rb', 'w') { |file| file.truncate(0) }

data["_embedded"]["events"].each do |event|
    name = event["name"]
    location = event["_embedded"]["venues"][0]["city"]["name"]
    venue = event["_embedded"]["venues"][0]["name"]
    if event["classifications"][0]["genre"] == nil
      genre = "UNKNOWN"
    else
      genre = event["classifications"][0]["genre"]["name"]
    end
    date = event["dates"]["start"]["localDate"]
    start_time = event["dates"]["start"]["localTime"]
    if event["priceRanges"] == nil
      price = nil
    else
      price = event["priceRanges"][0]["min"]
    end
    seed_line = "Event.create(name: \"#{name}\",location: \"#{location}\",venue: \"#{venue}\",genre: \"#{genre}\",date: \"#{date}\",start_time: \"#{start_time}\",price: \"#{price}\")"
    File.open('./db/seeds.rb',"a") do |line|
      line.puts "\r" + seed_line
    end
end
