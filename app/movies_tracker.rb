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
    puts "   Movie Tracker: #{menu}"
    puts "======================================="
end

def login
    clear_screen
    puts
    puts "  --  Welcome to Movie Tracker!!!  --"
    puts "======================================="
    main_menu
end

def main_menu
    menu = "main"
    puts
    puts
    puts "Are you a new or returning user?"
    puts
    puts "* Type 1 for a returning user"
    puts "* Type 2 to create a new profile"
    puts "* Type 'Q' or 'Quit' to exit"
    puts
    puts
    print "=> "
    response = gets.chomp
    response = response.downcase
    check_responses(response, menu)
end

def check_responses(response, menu)
    if response == '1' and User.all.size != 0
        logging_in_user
    elsif response == '1' and User.all.size == 0
        puts
        puts "There are currently no users.\nYou must create a new profile.\n(Press Enter to continue)"
        gets
        login
    elsif response == '2'
        create_profile
    elsif response == 'q' or response == 'quit' or response == 'exit'
        exit
    else
        menu_banner("Main Menu")
        main_menu
    end

def create_profile
    menu_banner("Profile Creation")
    menu = "profile"
    puts
    puts "Create a new user profile. A name is required.\nIt must be between 6 and 16 characters long.\n(Type 'Q' to exit or 'B' to go back)"
    puts
    print "=> "
    response = gets.chomp
    check_responses(response, menu)
    if response.length < 6 or response.length > 16
        puts
        puts "Error: User name must be between 6 and 16 characters long.\n(Press Enter to continue)"
        gets
        create_profile
    end
    if User.all.size == 0
        User.create(name: response)
    else
        for index in 0...User.all.size
            if User.all[index].name.downcase == response.downcase
                puts
                puts "Sorry, that user name is already taken. Please try again."
                gets
                create_profile
            end
        end
        User.create(name: response)
    end

end




    