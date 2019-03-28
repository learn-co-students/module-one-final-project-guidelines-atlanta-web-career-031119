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
    entry = @@prompt.ask("Please enter the date you want to look for: (YYYY/MM/DD)")
    list = Event.where('date = ?', entry)
    if list == []
      puts "Sorry no events on this day. Choose again."
      self.by_date
    else
    choices = list.map{|x| x.name}
    selection = @@prompt.select("Select Your Event", choices)
    display = display_event(selection)
    ticket_options(display)
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
    display = display_event(selection)
    ticket_options(display)
    end
  end

  def self.by_venue
    list = Event.all.map { |x| x.venue  }
    entry = @@prompt.select("Please select from the following venues:", list.uniq)
    events = Event.where('venue = ?', entry)
    choices = events.map{|x| x.name}
    selection = @@prompt.select("Select Your Event", choices)
    display = display_event(selection)
    ticket_options(display)
  end

  def self.by_genre
    list = Event.all.map { |x| x.genre  }
    entry = @@prompt.select("Please select from the following genres:", list.uniq)
    events = Event.where('genre = ?', entry)
    choices = events.map{|x| x.name}
    selection = @@prompt.select("Select Your Event", choices)
    display = display_event(selection)
    ticket_options(display)
  end

  def self.by_name
    list = Event.all.map { |x| x.name  }
    entry = @@prompt.select("Please select from the following events:", list.uniq)
    events = Event.where('name = ?', entry)
    choices = events.map{|x| x.name}
    selection = @@prompt.select("Select Your Event", choices)
    display = display_event(selection)
    ticket_options(display)
  end

  def self.wish_list
    wish_tickets = Ticket.where('status = ? AND user_id = ?', 'wish', @user.id)
    if wish_tickets == nil
      puts "You haven't chosen anything yet!?!"
      main_menu
    else
      my_wish_list = wish_tickets.map do |ticket|
       x = {}
       x[:name] = Event.find(ticket.event_id).name
       x[:value] = ticket.id
       x
      end
    end
    selection = @@prompt.select("Select an Event for more details and to purchase a ticket", my_wish_list)

    self.display_event_from_wishlist(selection)
  end

  def self.bought_list
    Ticket.where('status = ? AND user_id = ?', 'bought', @user.id)
  end

  def self.upcoming_events

    my_bought_events = self.bought_list.map {|ticket| Event.find(ticket.event_id) }

    my_upcoming_events = my_bought_events.select {|event| event.date > DateTime.now.to_s[0..9] }
    #my_upcoming_list = my_upcoming_events.map {|event| event.name }
    my_upcoming_list = my_upcoming_events.map do |event|
     x = {}
     x[:name] = event.name
     x[:value] = event.id
     x
   end
    selection = @@prompt.select("Here are your Upcoming Events:", my_upcoming_list)
    display_event(selection)
    selection2 = @@prompt.select("Next?", ["Leave a Comment", "View Other Upcoming Events", "Return to Main Menu"])
    if selection2 == "Leave a Comment"
      add_comment(selection)
    elsif
      selection2 =="View Other Upcoming Events"
      upcoming_events
    else
      main_menu
    end
  end

  def self.past_events
    my_bought_events = self.bought_list.map {|ticket| Event.find(ticket.event_id) }
    my_past_events = my_bought_events.select {|event| event.date < DateTime.now.to_s[0..9] }
    my_past_list = my_past_events.map {|event| event.name }
    selection = @@prompt.select("Here are your Past events", my_past_list)
    display_event(selection)
    selection2 = @@prompt.select("Next?", ["View Other Past Events", "Return to Main Menu"])
    if selection2 == "View Other Past Events"
      past_events
    else
      main_menu
    end
  end

  def dashboard
  end

  def self.logout
    puts "Thanks for stopping by!"
    self.call
  end

  def self.display_event(selection)

    display = Event.find(selection)
    puts "Selected Event:"
    puts display.date, display.name
    puts display.venue, display.location
    display
  end

  def self.ticket_options(display)
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

  def self.display_event_from_wishlist(selection)
    display1 = Ticket.find(selection)
    display = Event.find(display1.event_id)
    puts "Selected Event:"
    puts display.date, display.name
    puts display.venue, display.location
    options = ["Buy this ticket","Remove from Wishlist","Return to Search","Return to Main Menu"]
    choice = @@prompt.select("What would you like to do?", options)
    if choice == "Buy this ticket"
      self.update_ticket_status(selection)
      puts "Great! What would you like to do next?"
      main_menu
    elsif
      choice == "Remove from Wishlist"
      Ticket.delete(selection)
      puts "We have cleared that out for you. What would you like next?"
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

    Ticket.update(selection, :status => "bought")

    main_menu
  end

  def self.add_comment(selection)

    comment = @@prompt.multiline("Enter your comments here:")
    # ask = @@prompt.yes?('Would you recomment this event?')
    # recommend = if ask == Yes
    #   1
    # else
    #   0
    # end
    x = Review.create(user_id: @user.id, event_id: selection,content: comment, recommend: nil)
    puts "Thanks for your TicTalk!"
    main_menu
  end

  #def self.find_or_create_ticket(display, selection)
  #  if Ticket.where('user_id = ? AND event_id = ? AND status = ?', @user.id, display.id, "wish")



end
