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

def main_menu
    clear_screen
    puts
    puts "  --  Welcome to Movie Tracker!!!  --"
    puts "======================================="
    # if User.all.size == 0
    #     create_profile
    # end
    puts
    puts
    puts "Are you a new or returning user?"
    puts
    puts "* Type 1 for returning"
    puts "* Type 2 to create a new profile"
    puts "* Type 'Q' or 'Quit' to exit"
    puts "* Or type 'Help' for help"
    puts
    print "=> "
    response = gets.chomp
    response = response.downcase
    if response == '1'
        display_users
    elsif response == '2'
        create_profile
    elsif response == 'q' or response == 'quit' or response == 'exit'
        exit
    elsif response == 'h' or response == 'help'
        display_help
    else
        main_menu
    end
end

def create_profile









main_menu
    