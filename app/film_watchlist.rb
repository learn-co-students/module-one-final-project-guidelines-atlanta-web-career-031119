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
    puts
end

def login
    clear_screen
    puts
    puts "  --  Welcome to Film Watchlist!!!  --"
    puts "========================================"
    puts "   Where we watch your films for you!"
    puts
    puts
    main_menu
end

def main_menu
    menu = "main"
    puts "Are you a new or returning user?"
    puts
    puts " 1) Returning user"
    puts " 2) Create a new profile"
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
    if menu == 'profile' or menu == 'logging in' or menu == "user"
        if response == 'm' or response == 'main' or response == 'main menu'
            menu_banner("Main Menu")
            main_menu
        end
    end
end

def go_back_menu
    puts "\n(Type 'Q' to exit or 'M' to go back to the main menu)\n"
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
    puts " 1) View Movie list"
    puts " 2) Search for movies"
    puts " 3) Change user name"
    puts " 4) Switch user"
    puts " 0) Delete profile (Warning!!!)"
    go_back_menu
    print "=> "
    response = gets.chomp
    check_responses(response, menu)
    if response == '1'
        view_watchlist(current_user)
    elsif response == '2'
        movie_search(current_user)
    elsif response == '4'
        logging_in_user
    elsif response == '0'
        delete_profile(current_user)
    elsif response == '3'
        change_user_name(current_user)
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

def view_watchlist(current_user)
    movie_list = []
    MovieWatchlist.all.each do |item|
        if item.user_id == current_user.id
            movie_list << item.movie
        end
    end
    menu_banner(current_user.name)
    if movie_list.size == 0
        puts "* Unfortunately, you don't have any movies in your list yet.\nYou should search for movies to add. *"
        gets
        user_menu(current_user)
    end
    puts "Current list:"
    for index in 0...movie_list.size
        if index > 99
            puts " #{ index + 1 })\t #{ movie_list[index].title }"
        end
        if index > 10
            puts "  #{ index + 1 })\t #{ movie_list[index].title }"
        end
        if index < 10
            puts "   #{ index + 1 })\t #{ movie_list[index].title }"
        end
    end
end


    