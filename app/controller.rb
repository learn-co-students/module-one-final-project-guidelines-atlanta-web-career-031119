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
    options = ["Search","My Wish List","My Upcoming Events","My Past Events","Dashboard","Logout"]
    choice = @@prompt.select("Main Menu", options)
    if choice == "Search"
      self.run_search
    elsif
      choice == "My Wish List"
      self.wish_list
    elsif
      choice == "My Upcoming Events"
      upcoming_events
    elsif
      choice == "My Past Events"
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
    options = ["By Date","By Location","By Genre","By Venue","By Name","Return to Main Menu"]
    choice = @@prompt.select("Search Menu", options)
    if choice == "By Date"
      self.by_date
    elsif
      choice == "By Location"
      self.by_location
    elsif
      choice == "By Genre"
      self.by_genre
    elsif
      choice == "By Venue"
      self.by_venue
    elsif
      choice == "By Name"
      self.by_name
    elsif
      choice == "Return to Main Menu"
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
    display_event(selection)
    end
  end

  def self.by_location
    entry = @@prompt.ask("Please enter the city you want to search:")
    list = Event.where('location = ?', entry)
    if list == []
      puts "Sorry no events in this location. Choose again."
      self.by_location
    else
    choices = list.map{|x| x.name}
    selection = @@prompt.select("Select Your Event", choices)
    display_event(selection)
    end
  end

  def self.by_venue
    entry = @@prompt.ask("Please enter the venue you want to search:")
    list = Event.where('venue = ?', entry)
    if list == []
      puts "Sorry no events in this location. Choose again."
      self.by_location
    else
    choices = list.map{|x| x.name}
    selection = @@prompt.select("Select Your Event", choices)
    display_event(selection)
    end
  end

  def self.by_genre
    list = Event.all.map { |x| x.genre  }
    entry = @@prompt.select("Please select from the following genres:", list.uniq)
    events = Event.where('genre = ?', entry)
    choices = events.map{|x| x.name}
    selection = @@prompt.select("Select Your Event", choices)
    display_event(selection)

  end

  def self.by_name
    entry = @@prompt.ask("Please enter the name of the event you want to search for:")
    list = Event.where('name = ?', entry)
    if list == []
      puts "Sorry no events by that name. Choose again."
      self.by_location
    else
    choices = list.map{|x| x.name}
    selection = @@prompt.select("Select Your Event", choices)
    display_event(selection)
    end
  end

  def self.wish_list
    wish_tickets = Ticket.where('status = ? AND user_id = ?', 'wish', @user.id)
    my_wish_list = wish_tickets.map do |ticket|
      x = {}
      x[:name] = Event.find(ticket.event_id).name
      x[:value] = Event.find(ticket.event_id).id
      x
    end
    selection = @@prompt.select("Which one would you like to buy?", my_wish_list)
    self.update_ticket_status(selection)
  end

  def self.bought_list
    Ticket.where('status = ? AND user_id = ?', 'bought', @user.id)
  end

  def self.upcoming_events
    my_bought_events = self.bought_list.map {|ticket| Event.find(ticket.event_id) }
    # binding.pry
    my_upcoming_events = my_bought_events.select {|event| event.date > DateTime.now.to_s[0..9] }
    my_upcoming_list = my_upcoming_events.map {|event| event.name }
    selection = @@prompt.select("Here are your Upcoming Events:", my_upcoming_list)
  end

  def self.past_events
    my_bought_events = self.bought_list.map {|ticket| Event.find(ticket.event_id) }
    my_past_events = my_bought_events.select {|event| event.date < DateTime.now.to_s[0..9] }
    my_past_list = my_past_events.map {|event| event.name }
    selection = @@prompt.select("Here are your Past events", my_past_list)
  end

  def dashboard
  end

  def self.logout
    puts "Thanks for stopping by!"
    self.call
  end

  def self.display_event(selection)
    display = Event.find_by(name: selection)
    puts "Selected Event:"
    puts display.date, display.name
    puts display.venue, display.location
    options = ["Add to MyWish List","Buy a ticket","Return to Search","Return to Main Menu"]
    choice = @@prompt.select("What would you like to do?", options)
    if choice == "Add to MyWish List"
      self.add_to_wishlist(display)
      puts "Great! What would you like to do next?"
      main_menu
    elsif
      choice == "Buy a ticket"
      self.buy_a_ticket(display)
      puts "Great! What would you like to do next?"
      main_menu
    elsif
      choice == "Return to Search"
      self.run_search
    else
      choice == "Return to Main Menu"
      self.main_menu
    end
  end

  def self.add_to_wishlist(display)
    x = Ticket.create(user_id: @user.id, event_id: display.id, status: "wish")
  end

  def self.buy_a_ticket(display)
    x = Ticket.create(user_id: @user.id, event_id: display.id, status: "bought")
  end

  def self.update_ticket_status(selection)
    wish_tickets = Ticket.where('status = ? AND user_id = ?', 'wish', @user.id)
    ticket_to_update = wish_tickets.find{|x| x.name == selection}
    Ticket.update(ticket_to_update.id, :status => "bought")
  end

  #def self.find_or_create_ticket(display, selection)
  #  if Ticket.where('user_id = ? AND event_id = ? AND status = ?', @user.id, display.id, "wish")



end
