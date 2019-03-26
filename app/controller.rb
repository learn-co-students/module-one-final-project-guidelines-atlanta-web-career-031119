require 'tty-prompt'
require 'pry'
require_relative '../config/environment'
require_relative './models/user'
require_relative './models/event'
require_relative './models/review'
require_relative './models/ticket'


prompt = TTY::Prompt.new

class TicTalkApp
  @@prompt = TTY::Prompt.new
  attr_accessor :user

  def self.call
    @@prompt
    self.welcome_message
    self.main_menu
  end

  def self.welcome_message
    puts "Welcome to TicTalk"
    find_out_who
  end

  def self.find_out_who
    name = @@prompt.ask("Please enter your name to continue:")
    if User.all.find_by(name: name)
      puts "Welcome back!"
      @user = User.all.find_by(name: name)
    else
      puts "Nice to meet you!"
      @user = User.create(name: name.to_s)
    end
  end

  def self.main_menu
    choice = @@prompt.select("Main Menu", %w(Search My_Wish_List My_Upcoming_Events My_Past_Events Dashboard Logout))
    if choice == "Search"
      self.run_search
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
      self.logout
    end
  end

  def self.run_search
    choice = @@prompt.select("Search Menu", %w( By_Date By_Location By_Genre By_Venue By_Name Return_to_Main_Menu))
    if choice == "By_Date"
      self.by_date
    elsif
      choice == "By_Location"
      self.by_location
    elsif
      choice == "By_Genre"
      self.by_genre
    elsif
      choice == "By_Venue"
      self.by_venue
    elsif
      choice == "By_Name"
      self.by_name
    elsif
      choice == "Return_to_Main_Menu"
      self.main_menu
    end
  end

  def self.by_date
    entry = @@prompt.ask("Please enter the date you want to look for: (MM/DD/YY)")
    list = Event.where('date = ?', entry)
    if list == []
      puts "Sorry no events on this day. Choose again."
      self.by_date
    else
    choices = list.map{|x| x.name}
    selection = @@prompt.select("Select Your Event", choices)
    end
    binding.pry
  end

  def wish_list
  end

  def upcoming_events
  end

  def past_events
  end

  def dashboard
  end

  def self.logout
    puts "Thanks for stopping by!"
    self.call
  end
end
