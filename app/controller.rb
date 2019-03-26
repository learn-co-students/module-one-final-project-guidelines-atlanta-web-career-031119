require 'tty-prompt'
require 'pry'
require_relative '../config/environment'
require_relative './models/user'
require_relative './models/event'
require_relative './models/review'
require_relative './models/ticket'

<<<<<<< HEAD
prompt = TTY::Prompt.new
=======
class TicTalkApp

  attr_accessor :user

  def self.call
    prompt = TTY::Prompt.new
    welcome_message
    choice = main_menu
    next_step(choice)
  end

  def welcome_message
    puts "Welcome to TicTalk"
    find_out_who
  end

  def find_out_who
    name = prompt.ask("Please enter your name to continue:")
    if User.all.find_by(name: name)
      puts "Welcome back!"
      @user = User.all.find_by(name: name)
    else
      puts "Nice to meet you!"
      @user = User.create(name: name.to_s)
    end
  end

  def main_menu
    prompt.select("Main Menu", %w(Search My_Wish_List My_Upcoming_Events My_Past_Events Dashboard Logout))
  end


  def next_step(choice)
    if choice == "Search"
      run_search
    elsif 
      choice == "My_Wish_List"
      wish_list
    elsif 
      choice == "My_Upcoming_Events"
      upcoming_events
    elsif 
      choice == "My_Past_Event"
      past_events
    elsif 
      choice == "Dashboard"
      dashboard
    elsif 
      choice == "Logout"
      logout
    end
  end

  def run_search
  end

  def wish_list
  end

  def upcoming_events
  end

  def past_events
  end

  def dashboard
  end

  def logout
  end
end 
>>>>>>> 9a96b41e08d39760ccc70cda787b14b2a9a77e42
