require 'pry'
require 'rest-client'
require 'json'

def clear_screen
    if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
      system('cls')
    else
      system('clear')
    end
end

def menu_banner(menu = "Menu")
    clear_screen
    puts
    puts "   Film Watchlist: #{ menu }"
    puts "========================================"
    puts
end

def login
    clear_screen
    puts
    puts "  --  Welcome to Film Watchlist!!!  --"
    puts "========================================"
    puts "   Where we watch your films for you!"
    puts
    login_menu
end

def login_menu
    puts "Are you a new or existing user?"
    puts
    puts " 1) Existing user"
    puts " 2) Create a new profile"
    puts
    puts " 3) View Program Statistics"
    puts
    puts "* Type 'Q' or 'Quit' to exit *"
    puts
    print "=> "
    response = gets.chomp
    check_responses(response)
    if response == '1' and User.all.size != 0
        logging_in_user
    elsif response == '1' and User.all.size == 0
        puts "\n* There are currently no users.\nYou must create a new profile. *\n(Press Enter to continue)"
        gets
        login
    elsif response == '2'
        create_profile
    elsif response == '3'
        view_movie_statistics
    else
        menu_banner("Login Menu")
        login_menu
    end
end

def check_responses(response)
    response = response.downcase
    if response == 'q' or response == 'quit' or response == 'exit'
        clear_screen
        exit
    end
    # if response == 'm' or response == 'main' or response == 'main menu'
    #     user_menu(current_user)
    # end
end

def go_back_menu
    puts "\n (Type 'Q' to exit or 'M' for main menu)"
end

def check_user_name(response)
    User.all.each do |user|
        if user.name.downcase == response.downcase
            return user.name
        end
    end
    false
end

def create_profile
    menu_banner("Profile Creation")
    create_new = false
    puts " Create a new user profile. A name is required.\n It must be between 6 and 16 characters long."
    puts
    puts " (Type 'Q' to quit)"
    puts
    print "=> "
    response = gets.chomp
    check_responses(response)
    if response.length < 6 or response.length > 16
        puts "\n* Error: User name must be between 6 and 16 characters long. *\n (Press Enter to continue...)"
        gets
        create_profile
    end
    if User.all.size == 0
        User.create(name: response, hidden: false)
        puts "\n* New user was created: #{ response }\n (Press Enter to continue...)"
        gets
        current_user = User.find(User.where(name: response).ids)[0]
        user_menu(current_user)
    end
    if User.all.size != 0
        create_new = check_user_name(response)
        if create_new != false
            puts "\n* Error: User name is already in use. Please try another name. *\n (Press Enter to continue...)"
            gets
            create_profile
        end
    end
    if create_new == false
        User.create(name: response, hidden: false)
        puts "\n* New user was created: #{ response }\n (Press Enter to continue...)"
        gets
        current_user = User.find(User.where(name: response).ids)[0]
        user_menu(current_user)
    end
    menu_banner("Login Menu")
    login_menu
end

def logging_in_user
    menu_banner("User Login")
    puts "   List of current Users:"
    puts "----------------------------"
    puts
    User.all.each do |user|
        if user.hidden == false
            puts "#ID: #{ user.id }\t -  Name: #{ user.name }"
        end
    end
    puts "\n* Enter either user name or user #ID to login."
    puts
    puts " (Type 'Q' to exit)"
    print "\n => "
    response = gets.chomp
    check_responses(response)
    if response.to_i != 0
        check_id = response.to_i
        User.all.each do |user|
            if user.id == check_id and user.hidden == false
                current_user = User.find(check_id)
                user_menu(current_user)
            end
        end
    end
    if check_user_name(response) != false
        user_name = check_user_name(response)
        current_user = User.find(User.where(name: user_name).ids)[0]
        user_menu(current_user)
    else
        puts "\n* That is an invalid user. Please try\n   again or create a new user profile. *\n (Press Enter to continue)"
        gets
        logging_in_user
    end
end

def user_menu(current_user)
    menu_banner(current_user.name)
    puts " 1) View your movie list"
    puts " 2) Search for movies"
    puts
    puts " 7) Change user name"
    puts " 8) Switch user"
    puts
    puts " 0) Delete profile (Warning!!!)"
    puts 
    puts " (Type 'Q' to quit)"
    puts
    print " => "
    response = gets.chomp
    check_responses(response)
    if response == '1'
        view_watchlist(current_user)
    elsif response == '2'
        movie_search(current_user)
    elsif response == '8'
        logging_in_user
    elsif response == '0'
        delete_profile(current_user)
    elsif response == '7'
        change_user_name(current_user)
    else
        user_menu(current_user)
    end
end

def change_user_name(current_user)
    menu_banner(current_user.name)
    puts " Current user name for this profile is: #{current_user.name}"
    puts " Name must be bewtween 6 and 16 characters in length."
    puts
    puts " What would you like your new user name be?\n (Or you can leave to field blank for no change)"
    go_back_menu
    puts
    print " => "
    response = gets.chomp
    check_responses(response)
    if response.size == 0 or response = ''
        user_menu(current_user)
    elsif response == 'm' or response == 'main' or response == 'main menu'
        user_menu(current_user)
    end
    if response.length < 6 or response.length > 16
        puts "\n* Name is not the correct length. Must be be 6-16 characters long. *\n (Press Enter to continue)"
        gets
        change_user_name(current_user)
    end
    existing = check_user_name(response)
    if existing == false
        User.where(id: current_user.id).update(name: response)
        current_user = User.find(User.where(name: response).ids)[0]
        puts "\n* User name was changed to #{current_user.name}! *"
        gets
        user_menu(current_user)
    elsif existing != false and current_user.name == existing
        User.where(id: current_user.id).update(name: response)
        current_user = User.find(User.where(name: response).ids)[0]
        puts "\n* User name was changed to #{current_user.name}! *"
        gets
        user_menu(current_user)
        # puts "\n* Sorry, that name is already the name of this profile.\nPlease choose another... *"
        # gets
        # change_user_name(current_user)
    elsif existing != false
        puts "\n* Sorry, that name is already in use by another user.\n   Please choose another name. *\n (Press Enter to continue...)"
        gets
        change_user_name(current_user)
    end
end

def delete_profile(current_user)
    menu_banner(current_user.name)
    puts "**! Deleting this profile will delete all associated data\n    and watchlists! Are you sure you want to do this? !**\n\n (Type out the name of the profile to delete it, or anything else to go back)"
    puts
    print " !? "
    response = gets.chomp
    yes_no = check_user_name(response)
    if yes_no == false
        user_menu(current_user)
    elsif yes_no == current_user.name
        # MovieWatchlist.destroy(MovieWatchlist.where(user_id: current_user.id).ids)
        User.update(User.where(id: current_user.id), hidden: true, name: "deleted_user_#{current_user.id}")
        # User.destroy(User.where(id: current_user.id))
        puts "User #{yes_no} was removed!\n (Press Enter to continue)"
        gets
        login
    end
    user_menu(current_user)
end

def movie_search(current_user)
    menu_banner("Search Menu")
    puts " Searching for Movies!\n\n You can search for movies by title to get information about them.\n"
    puts
    puts " 1) Feeling Lucky! search      (returns the first closest match)"
    puts " 2) Top ten hits search        (returns up to ten movies with the title in the name)"
    puts " 3) View the current database  (returns a list of movies that all users have saved)"
    puts " 4) View other user's reviews"
    go_back_menu
    puts
    print " => "
    response = gets.chomp.downcase
    check_responses(response)
    if response == 'm' or response == 'main' or response == 'main menu'
        user_menu(current_user)
    elsif response == '1'
        lucky_search(current_user)
    elsif response == '2'
        broad_search(current_user)
    elsif response == '3'
        view_database(current_user)
    elsif response == '4'
        view_users_reviews(current_user)
    else
        movie_search(current_user)
    end
end

def broad_search(current_user)
    menu_banner("Broad Search")
    puts " Enter the name of a movie that you would like to find:\n"
    go_back_menu
    print " => "
    response = gets.chomp.downcase
    check_responses(response)
    if response == 'm' or response == 'main' or response == 'main menu'
        user_menu(current_user)
    end
    movie_info = JSON.parse(RestClient.get("http://www.omdbapi.com/?s=#{response}&apikey=92d4118f&"))
    if movie_info.keys.include?("Error")
        puts "* Uh oh, we didn't find any results for that movie. Try checking the spelling and search again.\n (Press Enter to continue...)"
        gets
        broad_search(current_user)
    end
    search_results = []
    movie_info["Search"].each do |movie|
      search_results << movie["Title"]
    end
    movie_info2 = []
    for index in 0...search_results.size
      info = JSON.parse(RestClient.get("http://www.omdbapi.com/?t=#{search_results[index]}&apikey=92d4118f&"))
      movie_info2 << info
    end
    for index in 0...movie_info2.size
        check = Movie.where(title: movie_info2[index]["Title"], release_date: movie_info2[index]["Released"])
        if check.size == 0
            add_movie_to_database(movie_info2[index])
            puts "* New movie detected! Automatically added to the database! *"
        end
    end
    id_nums = []
    for index in 0...movie_info2.size
        id_nums << Movie.where(title: movie_info2[index]["Title"], release_date: movie_info2[index]["Released"]).ids[0]
    end
    info = Movie.find(id_nums)
    menu_banner("Search Results")
    puts " Here are your search results:"
    for index in 0...info.size
        if info[index].title == nil
            next
        end
        puts " --- ##{index+1} ---"
        display_movie_info(info[index])
    end
    puts "* Type in the number of the search result you\n  would like to add to your watchlist:"
    puts
    go_back_menu
    puts
    while true
        print " => "
        response = gets.chomp.downcase
        check_responses(response)
        if response == 'm' or response == 'main' or response == 'main menu'
            user_menu(current_user)
        end
        response = response.to_i
        if response != 0 and response <= info.size and response > 0
            check = MovieWatchlist.where("user_id = #{current_user.id} and movie_id = #{info[response-1].id}")
            if check.size != 0 and check[0].keep_in_list == true
                puts "* You already have this movie in your list! *\n(Press Enter to continue...)"
                gets
                movie_search(current_user)
            elsif check.size != 0 and check[0].keep_in_list == false
                MovieWatchlist.update(MovieWatchlist.where("user_id = #{current_user.id} and movie_id = #{info[response-1].movie_id}"), keep_in_list: true)
                puts "* Movie was added back into your list! *\n (Press Enter to continue...)"
                gets
                movie_search(current_user)
            end
            MovieWatchlist.create(user_id: current_user.id, movie_id: info[response-1].id, rating: 0.0, review: "Has not been reviewed by you yet.", watched: false, keep_in_list: true)
            puts "* Movie '#{info[response-1].title}' was added to your watchlist! We'll be sure to keep an eye on it for you. *\n (Press Enter to continue...)"
            gets
            movie_search(current_user)
        end
        puts "* Please enter a number on the list or a menu option. *\n (Press Enter to continue...)"
        gets
    end
end

def view_database(current_user)
    menu_banner("All User's Saved Movies")
    puts " Here is a list of all searches done by all users:"
    puts
    for index in 0...Movie.all.size
        if Movie.all[index].title == nil
            next
        end
        puts " --- ##{Movie.all[index].id} ---"
        display_movie_info(Movie.all[index])
    end
    puts " Type in the number of the search result if you\n would like to add it to your watchlist:"
    go_back_menu
    puts
    while true
        print " => "
        response = gets.chomp.downcase
        check_responses(response)
        if response == 'm' or response == 'main' or response == 'main menu'
            user_menu(current_user)
        end
        response = response.to_i
        if response != 0 and response <= Movie.all.size and response > 0
            check = MovieWatchlist.where("user_id = #{current_user.id} and movie_id = #{Movie.all[response-1].id}")
            if check.size != 0 and check[0].keep_in_list == true
                puts "* You already have this movie in your list! *\n(Press Enter to continue...)"
                gets
                movie_search(current_user)
            elsif check.size != 0 and check[0].keep_in_list == false
                MovieWatchlist.update(MovieWatchlist.where("user_id = #{current_user.id} and movie_id = #{Movie.all[response-1].id}"), keep_in_list: true)
                puts "* Movie was added back into your list! *\n (Press Enter to continue...)"
                gets
                movie_search(current_user)
            end
            MovieWatchlist.create(user_id: current_user.id, movie_id: Movie.all[response-1].id, rating: 0.0, review: "Has not been reviewed by you yet.", watched: false, keep_in_list: true)
            puts
            puts "* Movie '#{Movie.all[response-1].title}' was added to your watchlist! We'll be sure to keep an eye on it for you. *\n (Press Enter to continue)"
            gets
            movie_search(current_user)
        end
        puts "* Please enter a number on the list or a menu option. *\n (Press Enter to continue...)"
        gets
    end
end


def add_movie_to_database(movie_info)
    Movie.create(title: movie_info["Title"], release_date: movie_info["Released"], plot: movie_info["Plot"], runtime: movie_info["Runtime"], rating: movie_info["imdbRating"].to_f, main_cast: movie_info["Actors"], genre: movie_info["Genre"])
end

def display_movie_info(info)
    puts " Movie's information:"
    puts
    puts " Title        ~  #{ info.title }"
    puts " Release date ~  #{ info.release_date }"
    puts " Avg. Rating  ~  #{ info.rating } / 10"
    puts " Runtime      ~  #{ info.runtime }"
    puts " Main cast    ~  #{ info.main_cast }"
    puts " Genre        ~  #{ info.genre } "
    puts " Plot         ~  #{ info.plot[0..100] }"
    puts "                 #{ info.plot[101..200] }"
    puts "                 #{ info.plot[201..300] }"
    puts "                 #{ info.plot[301..400] }"
    puts
end

def lucky_search(current_user)
    menu_banner("Feeling Lucky!")
    puts "Enter the name of the movie you would like to find:\n"
    go_back_menu
    puts
    print " => "
    response = gets.chomp.downcase
    check_responses(response)
    if response == 'm' or response == 'main' or response == 'main menu'
        user_menu(current_user)
    end
    movie_info = JSON.parse(RestClient.get("http://www.omdbapi.com/?t=#{response}&apikey=92d4118f&"))
    if movie_info.keys.include?("Error")
        puts "* Uh oh, we didn't find that movie. Try checking the spelling and search again.\n (Press Enter to continue...)"
        gets
        lucky_search(current_user)
    end
    check = Movie.where(title: movie_info["Title"], release_date: movie_info["Released"])
    if check.size == 0
        add_movie_to_database(movie_info)
        puts "* New movie detected! Automatically added to the database! *\n (Press Enter to continue...)"
        gets
    end
    id_num = Movie.where(title: movie_info["Title"], release_date: movie_info["Released"]).ids[0]
    info = Movie.find(id_num)
    while true
        menu_banner("Movie Info")
        display_movie_info(info)
        puts " Would you like to add this movie to your watchlist?\n(1 or 'Y' for yes, 2 or 'N' for no)"
        puts
        print " => "
        response = gets.chomp.downcase
        check_responses(response)
        if response == 'm' or response == 'main' or response == 'main menu'
            user_menu(current_user)
        end
        if response == '1' or response == 'y' or response == 'yes'
            check = MovieWatchlist.where("user_id = #{current_user.id} and movie_id = #{info.id}")
            if check.size != 0 and check[0].keep_in_list == true
                puts "* You already have this movie in your list! *\n(Press Enter to continue...)"
                gets
                movie_search(current_user)
            elsif check.size != 0 and check[0].keep_in_list == false
                MovieWatchlist.update(MovieWatchlist.where("user_id = #{current_user.id} and movie_id = #{info.id}"), keep_in_list: true)
                puts "* Movie was added back into your list! *\n (Press Enter to continue...)"
                gets
                movie_search(current_user)
            end
            MovieWatchlist.create(user_id: current_user.id, movie_id: info.id, rating: 0.0, review: "Has not been reviewed by you yet.", watched: false, keep_in_list: true)
            puts "* Movie was added to your watchlist! We'll be sure to keep an eye on it for you. *\n (Press Enter to continue)"
            gets
            movie_search(current_user)
        elsif response == '2' or response == 'n' or response == 'no'
            movie_search(current_user)
        else
            next
        end
    end
end

def get_user_movie_list(current_user)
    movie_list = []
    MovieWatchlist.all.each do |item|
        if item.user_id == current_user.id and item.keep_in_list == true
            movie_list << item
        end
    end
    return movie_list
end

def view_watchlist(current_user)
    movie_list = get_user_movie_list(current_user)
    menu_banner(current_user.name)
    if movie_list.size == 0
        puts "* Aww, it seems you don't have any movies in your list yet. *\n* You should search for movies and add them in!  <(^_^)> *\n  (Press Enter to continue...)"
        gets
        user_menu(current_user)
    end
    puts " Your current list:"
    puts
    for index in 0...movie_list.size
        if index > 99
            puts " #{ index + 1 })\t #{ movie_list[index].movie.title }"
        end
        if index > 9
            puts " #{ index + 1 })\t #{ movie_list[index].movie.title }"
        end
        if index < 10
            puts " #{ index + 1 })\t #{ movie_list[index].movie.title }"
        end
    end
    watchlist_menu(current_user, movie_list)
end

def watchlist_menu(current_user, movie_list)
    puts
    puts "* What would you like to do?"
    puts
    puts " 1) Check movie info"
    puts " 2) Watch a movie on the list"
    puts " 3) Remove a movie from list"
    puts " 4) View/Update your movie ratings/reviews"
    puts
    go_back_menu
    puts
    print " => "
    response = gets.chomp.downcase
    check_responses(response)
    if response == 'm' or response == 'main' or response == 'main menu'
        user_menu(current_user)
    end
    if response == '1'
        user_movie_info(current_user, movie_list)
    elsif response == '3'
        remove_movie_from_user_list(current_user, movie_list)
    elsif response == '4'
        update_user_rating_review(current_user, movie_list)
    elsif response == '2'
        user_movie_watch(current_user, movie_list)
    else
        view_watchlist(current_user)
    end
end

def view_users_reviews(current_user)
    menu_banner("User's Reviews")
    MovieWatchlist.all.each do |item|
        puts " ---------------------------------- "
        puts " User review by : #{item.user.name}"
        puts " Film reviewed  : #{item.movie.title}"
        puts " User's rating  : #{item.rating}"
        puts "    Review      : #{item.review}"
        puts
    end
    puts
    puts " (Press Enter to continue...)"
    gets
    movie_search(current_user)
end

def user_movie_watch(current_user, movie_list)
    puts
    puts "* Put in the number of the movie in the list\n  that you would like to watch (1 - #{movie_list.size}):"
    go_back_menu
    puts
    while true
        print " => "
        response = gets.chomp.downcase
        check_responses(response)
        if response == 'm' or response == 'main' or response == 'main menu'
            user_menu(current_user)
        end
        response = response.to_i
        if response != 0 and response <= movie_list.size and response > 0
            watchmovies(current_user, movie_list[response-1].movie.title)
        else
            puts "* Please enter a number for a movie on the list. *\n(Press Enter to continue)"
            gets
            next
        end
    end
end

def user_movie_info(current_user, movie_list)
    puts " Put in the number of the movie in the list that\n you would like to view the information for:\n(1 - #{movie_list.size})"
    while true
        print " => "
        response = gets.chomp.downcase
        check_responses(response)
        response = response.to_i
        if response != 0 and response <= movie_list.size and response > 0
            menu_banner("Movie Info")
            display_movie_info(movie_list[response - 1].movie)
            puts " Your rating: #{movie_list[response-1].rating} / 10"
            puts " Your review: #{movie_list[response-1].review}"
            puts 
            puts " (Press Enter to continue...)"
            gets
            view_watchlist(current_user)
        else
            puts "* Please enter a number for a movie on the list. *\n(Press Enter to continue)"
            gets
            next
        end
    end
end

def remove_movie_from_user_list(current_user, movie_list)
    puts
    puts " Which movie would you like to remove from your watchlist? (1 - #{movie_list.size})"
    puts
    go_back_menu
    while true
        puts
        print " => "
        response = gets.chomp
        check_responses(response)
        if response == 'm' or response == 'main' or response == 'main menu'
            user_menu(current_user)
        end
        response = response.to_i
        if response != 0 and response <= movie_list.size and response > 0
            MovieWatchlist.update(MovieWatchlist.where("user_id = #{current_user.id} and movie_id = #{movie_list[response-1].movie_id}"), keep_in_list: false)
            puts "* The movie  '#{movie_list[response-1].movie.title}'  was removed from your list.\nYour reviews and ratings are still saved and can still be modified. *\n (Press Enter to continue...)"
            gets
            view_watchlist(current_user)
        else
            puts "* Please enter a number for a movie on your list. *\n(Press Enter to continue)"
            gets
            next
        end
    end
end

def update_user_rating_review(current_user, movie_list)
    menu_banner("User Reviews")
    puts
    puts " Your current ratings/reviews:"
    puts
    movie_list = []
    MovieWatchlist.all.each do |item|
        if item.user_id == current_user.id
            movie_list << item
        end
    end
    for index in 0...movie_list.size
        if index > 99
            puts " #{ index + 1 })\t #{ movie_list[index].movie.title }"
        end
        if index > 10
            puts "  #{ index + 1 })\t #{ movie_list[index].movie.title }"
        end
        if index < 10
            puts "   #{ index + 1 })\t #{ movie_list[index].movie.title }"
        end
        puts "            Your rating: #{movie_list[index].rating} / 10"
        puts "            Your review: #{movie_list[index].review.capitalize}"
        puts 
    end
    puts " Enter the number for the movie you wish to update:"
    go_back_menu
    puts
    print " => "
    response = gets.chomp.downcase
    check_responses(response)
    if response == 'm' or response == 'main' or response == 'main menu'
        user_menu(current_user)
    end
    response = response.to_i
    if response != 0 and response <= movie_list.size and response > 0
        puts
        puts " Movie: #{movie_list[response-1].movie.title}"
        while true
            puts " Enter in your new rating between (0.1 - 10.0): "
            puts
            print " => "
            rating = gets.chomp.downcase
            if rating == 'main menu' or rating == 'main' or rating == 'm'
                user_menu(current_user)
            end
            check_responses(rating)
            if rating.to_f != 0.0
                rating = rating.to_f.round(1)
            end 
            if rating.class == Float and rating > 0.0 and rating < 10.1
                MovieWatchlist.update(MovieWatchlist.where("user_id = #{current_user.id} and movie_id = #{movie_list[response-1].movie_id}"), rating: rating)
            else
                puts "* Please enter a number between 0.1 and 10.0. *\n (Press Enter to continue...)"
                gets
                next
            end
            puts " Enter in your new movie review: "
            print " => "
            review = gets.chomp.downcase
            check_responses(review)
            if review == 'main menu' or review == 'main' or review == 'm'
                user_menu(current_user)
            end
            if review.length == 0 or review == ''
                movie_list = get_user_movie_list(current_user)
                update_user_rating_review(current_user, movie_list)
            end
            MovieWatchlist.update(MovieWatchlist.where("user_id = #{current_user.id} and movie_id = #{movie_list[response-1].movie_id}"), review: review)
            puts
            puts "* Your updates have been made!\n (Press Enter to continue...)"
            gets
            movie_list = get_user_movie_list(current_user)
            update_user_rating_review(current_user, movie_list)
        end
    else
        puts "* Please enter a number for a movie on the list. *\n(Press Enter to continue)"
        gets
        update_user_rating_review(current_user, movie_list)
    end
end

def watchmovies(current_user, movie_title)
    Launchy.open("https://www.vudu.com/content/movies/search?minVisible=0&returnUrl=%252F&searchString=#{movie_title}")
    # Launchy.open("https://ww1.putlockerfree.sc/search-query/#{moviesname}/")
    view_watchlist(current_user)
end

def mostpopularmovie
    x = MovieWatchlist.all.group(:movie_id).count
    y = x.sort_by{|k,v| -v}.first
    y[0]
    z = Movie.where(id: y[0])
    puts "* The most popular film  ~  #{z[0].title}"
end

def mostwatchmovie
    x = MovieWatchlist.where("watched = ?",true).pluck(:movie_id)
    hash = {}
    x.each do |keys|
        if hash.has_key? (keys)
            hash[keys] += 1
        else
            hash[keys] = 1
        end
    end   
    x = hash.sort_by{|keys,values| -values}.first
    y = Movie.where("id = #{x[0]}").pluck(:title)
    puts "* The most viewed film  ~  #{y[0]}"
end

def highestuserrating
    x = MovieWatchlist.maximum(:rating)
    y = MovieWatchlist.where("rating = #{x}")
    #puts y[0]
    i = 0
    while i < y.length
        puts "* The film with the highest user rating  ~  #{y[i].movie.title}\n \tAt an average rating of ~ #{y[i].rating}"
        i +=1
    end
end

def highestrating
    x = Movie.maximum(:rating)
    y = Movie.where("rating = #{x}")
    #puts y[0]
    i = 0
    while i < y.length
        puts "* The film with the highest rating  ~  #{y[i].title}\n \tAt an average rating of ~ #{y[i].rating}"
        i +=1
    end
end

def usermaxmovies
    x = MovieWatchlist.all.group(:user_id).count
    y = x.sort_by{|key,values| -values}.first
    z = User.where("id = #{y[0]}").pluck(:name)
    puts "* The user with the highest number of films is  ~  #{z.join}"
    # binding.pry
end

def view_movie_statistics
    menu_banner("Viewing Statistics")
    usermaxmovies
    puts
    highestrating
    puts
    highestuserrating
    puts
    mostwatchmovie
    puts
    mostpopularmovie
    puts
    puts "  Press Enter to continue..."
    gets
    login
end
# MovieWatchlist.group("movie_id").sort.first.movie.title