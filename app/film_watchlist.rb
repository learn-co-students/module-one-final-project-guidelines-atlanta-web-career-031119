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
    main_menu
end

def main_menu
    menu = "main"
    puts "Are you a new or returning user?"
    puts
    puts " 1) Returning user"
    puts " 2) Create a new profile"
    puts
    puts "* Type 'Q' or 'Quit' to exit *"
    puts
    puts
    print "=> "
    response = gets.chomp
    check_responses(response, menu)
    if response == '1' and User.all.size != 0
        logging_in_user
    elsif response == '1' and User.all.size == 0
        puts "\n* There are currently no users.\nYou must create a new profile. *\n(Press Enter to continue)"
        gets
        login
    elsif response == '2'
        create_profile
    else
        menu_banner("Main Menu")
        main_menu
    end
end

def check_responses(response, menu)
    response = response.downcase
    if response == 'q' or response == 'quit' or response == 'exit'
        clear_screen
        exit
    end
    if menu == 'profile' or menu == 'logging in' or menu == "user" or menu == 'search'
        if response == 'm' or response == 'main' or response == 'main menu'
            menu_banner("Main Menu")
            main_menu
        end
    end
end

def go_back_menu
    puts "\n(Type 'Q' to exit or 'M' to go back to the main menu)\n"
end

def go_back_user_menu
    puts "\n(Type 'Q' to quit, 'M' for main menu, or 'user_menu' for user menu)\n"
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
    menu = "profile"
    create_new = false
    puts "Create a new user profile. A name is required.\nIt must be between 6 and 16 characters long."
    go_back_menu
    puts
    print "=> "
    response = gets.chomp
    check_responses(response, menu)
    if response.length < 6 or response.length > 16
        puts "\n* Error: User name must be between 6 and 16 characters long. *\n(Press Enter to continue)"
        gets
        create_profile
    end
    if User.all.size == 0
        User.create(name: response)
        puts "\nNew user was created: #{ response }"
        gets
        menu_banner("Main Menu")
        main_menu
    end
    if User.all.size != 0
        create_new = check_user_name(response)
        if create_new != false
            puts "\n* Error: User name is already in use. Please try another name. *"
            gets
            create_profile
        end
    end
    if create_new == false
        User.create(name: response)
        puts "\nNew user was created: #{ response }"
        gets
        menu_banner("Main Menu")
        main_menu
    end
    menu_banner("Main Menu")
    main_menu
end

def logging_in_user
    menu = "logging in"
    menu_banner("User Login")
    puts "   List of current Users:"
    puts "----------------------------"
    puts
    User.all.each do |user|
        puts "#ID: #{ user.id } \t-  Name: #{ user.name }"
    end
    puts "\nEnter either user name or user #ID to login."
    go_back_menu
    print "\n => "
    response = gets.chomp
    check_responses(response, menu)
    if response.to_i != 0
        check_id = response.to_i
        User.all.each do |user|
            if user.id == check_id
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
        puts "\n* That is an invalid user. Please try\nagain or create a new user profile. *"
        gets
        logging_in_user
    end
end

def user_menu(current_user)
    menu_banner(current_user.name)
    menu = "user"
    puts " 1) View your movie list"
    puts " 2) Search for movies"
    puts " 3) View movie statistics"
    puts " 4) Change user name"
    puts " 5) Switch user"
    puts " 0) Delete profile (Warning!!!)"
    go_back_menu
    puts
    print " => "
    response = gets.chomp
    check_responses(response, menu)
    if response == '1'
        view_watchlist(current_user)
    elsif response == '2'
        movie_search(current_user)
    elsif response == '5'
        logging_in_user
    elsif response == '0'
        delete_profile(current_user)
    elsif response == '4'
        change_user_name(current_user)
    elsif response == '3'
        view_movie_statistics(current_user)
        # MovieWatchlist.group("movie_id").sort.first.movie.title
    else
        user_menu(current_user)
    end
end

def change_user_name(current_user)
    menu_banner(current_user.name)
    puts "Current user name for this profile is: #{current_user.name}"
    puts "Name must be bewtween 6 and 16 characters in length."
    puts
    puts "What would you like your new user name be?"
    go_back_menu
    print " => "
    response = gets.chomp
    check_responses(response, "user")
    if response.length < 6 or response.length > 16
        puts "\n* Name is not the correct length. Must be be 6-16 characters long. *"
        gets
        check_user_name(current_user)
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
        puts "\n* Sorry, that name is already in use by another user.\nPlease choose another name. *"
        gets
        change_user_name(current_user)
    end
end

def delete_profile(current_user)
    menu_banner(current_user.name)
    puts "Deleting this profile will delete all associated data\nand watchlists! Are you sure you want to do this?\n\n(Type out the name of the profile to delete it, or anything else to go back)\n"
    print " !? "
    response = gets.chomp
    yes_no = check_user_name(response)
    if yes_no == false
        user_menu(current_user)
    elsif yes_no == current_user.name
        MovieWatchlist.destroy(MovieWatchlist.where(user_id: current_user.id).ids)
        User.destroy(User.where(id: current_user.id))
        puts "User #{yes_no} was removed!"
        gets
        logging_in_user
    end
    user_menu(current_user)
end

def movie_search(current_user)
    menu_banner("Search Menu")
    puts " Searching for Movies!\n\n You can search for movies by title to get information about them.\n"
    puts
    puts " 1) Feeling lucky! search (returns first closest match)"
    puts " 2) Broad search (returns a number of movies with the title in the name)"
    puts " 3) Database search (returns movies that all users have saved)"
    go_back_user_menu
    print " => "
    response = gets.chomp.downcase
    check_responses(response, "user")
    if response == 'user_menu' or response == 'user' or response == 'u'
        user_menu(current_user)
    elsif response == '1'
        lucky_search(current_user)
    elsif response == '2'
        broad_search(current_user)
    elsif response == '3'
        database_search(current_user)
    elsif response == 'user_menu'
        user_menu(current_user)
    else
        movie_search(current_user)
    end
end

def add_movie_to_database(movie_info)
    Movie.create(title: movie_info["Title"], release_date: movie_info["Released"], plot: movie_info["Plot"], runtime: movie_info["Runtime"], rating: movie_info["imdbRating"].to_f, main_cast: movie_info["Actors"])
end

def display_movie_info(info)
    menu_banner("Movie Info")
    puts " Movie's information:"
    puts
    puts " Title        ~  #{ info.title }"
    puts " Release date ~  #{ info.release_date }"
    puts " Avg. Rating  ~  #{ info.rating }"
    puts " Runtime      ~  #{ info.runtime }"
    puts " Main cast    ~  #{ info.main_cast }"
    puts " Plot         ~  #{ info.plot[0..100] }"
    puts "                 #{ info.plot[101..200] }"
    puts "                 #{ info.plot[201..300] }"
    puts
end

def lucky_search(current_user)
    menu_banner("Feeling Lucky!")
    puts "Enter the name of the movie you would like to find:\n"
    go_back_user_menu
    print " => "
    response = gets.chomp
    check_responses(response, 'search')
    if response.downcase == 'user_menu'
        user_menu(current_user)
    end
    movie_info = JSON.parse(RestClient.get("http://www.omdbapi.com/?t=#{response}&apikey=92d4118f&"))
    check = Movie.where(title: movie_info["Title"], release_date: movie_info["Released"])
    if check.size == 0
        add_movie_to_database(movie_info)
        puts "New movie detected! Automatically added to database!"
        gets
    end
    id_num = Movie.where(title: movie_info["Title"], release_date: movie_info["Released"]).ids[0]
    info = Movie.find(id_num)
    while true
        display_movie_info(info)
        puts "Would you like to add this movie to your watchlist?\n(1 or 'Y' for yes, 2 or 'N' for no)"
        puts
        print " => "
        response = gets.chomp.downcase
        check_responses(response, 'search')
        if response == 'user_menu' or response == 'user' or response == 'u'
            user_menu(current_user)
        end
        if response == '1' or response == 'y' or response == 'yes'
            check = MovieWatchlist.where("user_id = #{current_user.id} and movie_id = #{info.id}")
            if check.size != 0
                puts "* You already have this movie in your list! *\n(Press Enter to continue...)"
                gets
                movie_search(current_user)
            end
            MovieWatchlist.create(user_id: current_user.id, movie_id: info.id, rating: 0.0, review: "Has not been reviewed yet.", watched: false)
            puts "* Movie was added to your watchlist! We'll be sure to keep an eye on it for you. *"
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
        if item.user_id == current_user.id
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
    puts "Your current list:"
    puts
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
    end
    watchlist_menu(current_user, movie_list)
end

def watchlist_menu(current_user, movie_list)
    puts
    puts "* What would you like to do?"
    puts
    puts " 1) Check movie info"
    puts " 2) Remove movie from list"
    puts " 3) Update your movie's rating/review"
    puts
    go_back_user_menu
    puts
    print " => "
    response = gets.chomp.downcase
    check_responses(response, "user")
    if response == '1'
        user_movie_info(current_user, movie_list)
    elsif response == '2'
        remove_movie_from_user_list(current_user, movie_list)
    elsif response == '3'
        update_user_rating_review(current_user, movie_list)
    else
        view_watchlist(current_user)
    end
 
end

def user_movie_info(current_user, movie_info)
    puts "Put in the number of the movie in the list that\nyou would like to view the information for:\n(1 - #{movie_info.size})"
    while true
        print " => "
        response = gets.chomp.downcase
        check_responses(response, 'user')
        response = response.to_i
        if response != 0 and response <= movie_info.size and response > 0
            display_movie_info(movie_info[response - 1].movie)
            puts " Your rating: #{movie_info[response-1].rating}"
            puts " Your review: #{movie_info[response-1].review}"
            gets
            view_watchlist(current_user)
        else
            puts "* Please enter a number for a movie on your list. *\n(Press Enter to continue)"
            gets
            next
        end
    end
end

def remove_movie_from_user_list(current_user, movie_list)
    binding.pry
end
