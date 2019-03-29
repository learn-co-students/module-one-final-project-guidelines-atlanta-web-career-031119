require 'tty-prompt'
require 'tty-font'
require 'pry'
require_relative '../config/environment'
require_relative './models/user'
require_relative './models/event'
require_relative './models/review'
require_relative './models/ticket'




class TicTalkApp
  @@prompt = TTY::Prompt.new
  @@qty = 0
  attr_accessor :user

  def self.call
    @@prompt
    self.welcome_message
    self.main_menu
  end

  def self.welcome_message
    font = TTY::Font.new(:straight)
    color = Pastel.new
    system "clear"
    puts color.yellow(font.write("Welcome to TicTalk"))
    find_out_who
  end

  def self.find_out_who
    name = @@prompt.ask("Please enter your name to continue:")
    system "clear"
    if User.all.find_by(name: name)
      puts "Welcome back #{name}!"
      @user = User.all.find_by(name: name)
    else
      puts "Nice to meet you #{name}!"
      @user = User.create(name: name.to_s)
    end
  end

  def self.main_menu
    options = ["Search","My Wish List","My Upcoming Events","My Past Events", "Logout"]
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
    entry = @@prompt.ask("Please enter the date you want to look for (YYYY-MM-DD):")
    list = Event.where('date = ?', entry)
    list2= list.select {|event| event.date >= DateTime.now.to_s[0..9] }
    if list2 == []
      puts "Sorry no events on this day. Choose again."
      self.by_date
    else
    choices = list2.map do |event|
     x = {}
     x[:name] = "#{event.name}\nDate: #{event.date} Venue: #{event.venue}"
     x[:value] = event.id
     x
   end
    selection = @@prompt.select("Select Your Event", choices)
    display = display_event(selection)
    ticket_options(display)
    end
  end

  def self.by_location
    entry = @@prompt.ask("Please enter the city you want to search:")
    list = Event.where('location = ?', entry)
    list2= list.select {|event| event.date >= DateTime.now.to_s[0..9] }
    if list2 == []
      puts "Sorry no events in this location. Choose again."
      self.by_location
    else
    choices = list2.map do |event|
     x = {}
     x[:name] = "#{event.name}\nDate: #{event.date} Venue: #{event.venue}"
     x[:value] = event.id
     x
   end
    selection = @@prompt.select("Select Your Event", choices)
    display = display_event(selection)
    ticket_options(display)
    end
  end

  def self.by_venue
    list = Event.all.map { |x| x.venue  }
    entry = @@prompt.select("Please select from the following venues:", list.uniq)
    events = Event.where('venue = ?', entry)
    list2= events.select {|event| event.date >= DateTime.now.to_s[0..9] }
    if list2 == []
      puts "Sorry no events in this venue. Choose again."
      self.by_venue
    else
     choices = list2.map do |event|
      x = {}
      x[:name] = "#{event.name}\nDate: #{event.date} Venue: #{event.venue}"
      x[:value] = event.id
      x
     end
   end
    selection = @@prompt.select("Select Your Event", choices)
    display = display_event(selection)
    ticket_options(display)
  end

  def self.by_genre
    list = Event.all.map { |x| x.genre  }
    entry = @@prompt.select("Please select from the following genres:", list.uniq)
    events = Event.where('genre = ?', entry)
    list2= events.select {|event| event.date >= DateTime.now.to_s[0..9] }
    if list2 == []
      puts "Sorry no events in this genre. Choose again."
      self.by_genre
    else
     choices = list2.map do |event|
      x = {}
      x[:name] = "#{event.name}\nDate: #{event.date} Venue: #{event.venue}"
      x[:value] = event.id
      x
     end
   end
    selection = @@prompt.select("Select Your Event", choices)
    display = display_event(selection)
    ticket_options(display)
  end

  def self.by_name
    list = Event.all.map { |x| x.name  }
    entry = @@prompt.select("Please select from the following events:", list.uniq)
    events = Event.where('name = ?', entry)
    list2= events.select {|event| event.date >= DateTime.now.to_s[0..9] }
    if list2 == []
      puts "Sorry no current events with this name. Choose again."
      self.by_name
    else
     choices = list2.map do |event|
      x = {}
      x[:name] = "#{event.name}\nDate: #{event.date} Venue: #{event.venue}"
      x[:value] = event.id
      x
     end
    end
     selection = @@prompt.select("Select Your Event", choices)
     display = display_event(selection)
     ticket_options(display)
  end

  def self.wish_list
    wish_tickets = Ticket.where('status = ? AND user_id = ?', 'wish', @user.id)
    if wish_tickets == []
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

    my_upcoming_events = my_bought_events.uniq.select {|event| event.date > DateTime.now.to_s[0..9] }
    my_upcoming_list = my_upcoming_events.map do |event|
     x = {}
     x[:name] = event.name
     x[:value] = event.id
     x
   end
    selection = @@prompt.select("Here are your Upcoming Events:", my_upcoming_list)
    display = display_event(selection)
    ticket_options_upcoming(display)
  end

  def self.ticket_options_upcoming(display)
    selection2 = @@prompt.select("Next?", ["Leave some TicTalk","Read some TicTalk", "View Other Upcoming Events", "Return to Main Menu"])
    if selection2 == "Leave some TicTalk"
      add_comment(display.id)
    elsif
      selection2 == "Read some TicTalk"
      view_comments_upcoming(display)
    elsif
      selection2 =="View Other Upcoming Events"
      system "clear"
      upcoming_events
    else
      system "clear"
      main_menu
    end
  end

  def self.past_events
    my_bought_events = self.bought_list.map {|ticket| Event.find(ticket.event_id) }
    my_past_events = my_bought_events.uniq.select {|event| event.date < DateTime.now.to_s[0..9] }
    if my_past_events == []
      system "clear"
      puts "You don\'t have any past events yet."
      main_menu
    else
     my_past_list = my_past_events.map do |event|
     x = {}
     x[:name] = event.name
     x[:value] = event.id
     x
    end
   end
    selection = @@prompt.select("Here are your Past events", my_past_list)
    display = display_event(selection)
    ticket_options_past(display)
  end

  def self.ticket_options_past(display)
    selection2 = @@prompt.select("Next?", ["Leave some TicTalk", "Read some TicTalk", "View Other Past Events", "Return to Main Menu"])
    if selection2 == "Leave some TicTalk"
      add_comment(display.id)
    elsif
      selection2 == "Read some TicTalk"
      view_comments_past(display)
    elsif selection2 == "View Other Past Events"
      system "clear"
      past_events
    else
      system "clear"
      main_menu
    end
  end

  # def dashboard
  # end

  def self.logout
    puts "Thanks for stopping by!"
    self.call
  end

  def self.display_event(selection)
    system "clear"
    display = Event.find(selection)
    qty = Ticket.where('event_id = ? AND user_id = ?', selection, @user.id)
    puts "Selected Event:"
    puts "="*30
    puts "Date: #{display.date}", "Name: #{display.name}", "Venue: #{display.venue}", "Location: #{display.location}", "Starting Price: $#{display.price}", "Number of Tickets #{qty.count}"
    puts "="*30
    display
  end

  def self.ticket_options(display)
    options = ["Read the TicTalk", "Add to MyWish List","Buy a ticket","Return to Search","Return to Main Menu"]
    choice = @@prompt.select("What would you like to do?", options)
    if choice == "Read the TicTalk"
      self.view_comments(display)
    elsif choice == "Add to MyWish List"
      system "clear"
      self.add_to_wishlist(display)
      puts "Great! What would you like to do next?"
      main_menu
    elsif
      choice == "Buy a ticket"
      system "clear"
      @@qty = get_qty
      self.buy_a_ticket(display)
      puts "Great! What would you like to do next?"
      main_menu
    elsif
      choice == "Return to Search"
      system "clear"
      self.run_search
    else
      choice == "Return to Main Menu"
      system "clear"
      self.main_menu
    end
  end


  def self.display_event_from_wishlist(selection)
    system "clear"
    display1 = Ticket.find(selection)
    display = Event.find(display1.event_id)
    puts "Selected Event:"
    puts "="*30
    puts "Date: #{display.date}", "Name: #{display.name}", "Venue: #{display.venue}", "Location: #{display.location}", "Starting Price: $#{display.price}"
    puts "="*30
    options = ["Buy this ticket","Remove from Wishlist","Return to Search","Return to Main Menu"]
    choice = @@prompt.select("What would you like to do?", options)
    if choice == "Buy this ticket"
      system "clear"
      update_ticket_status(selection)
    elsif
      choice == "Remove from Wishlist"
      system "clear"
      delete_ticket(selection)
    elsif
      choice == "Return to Search"
      self.run_search
    else
      choice == "Return to Main Menu"
      self.main_menu
    end
  end

  def self.add_to_wishlist(display)
    Ticket.create(user_id: @user.id, event_id: display.id, status: "wish")
  end

  def self.buy_a_ticket(display)
    @@qty.times do
      Ticket.create(user_id: @user.id, event_id: display.id, status: "bought")
    end
  end

  def self.update_ticket_status(selection)
    ticket = Ticket.find(selection)
    event = Event.find(ticket.event_id)
    @@qty = get_qty
    Ticket.update(selection, :status => "bought")
    buy_a_ticket(event)
    puts "Great! What would you like to do next?"
    main_menu
  end

  def self.delete_ticket(selection)

    Ticket.delete(selection)
    puts "We have cleared that out for you. What would you like next?"
    main_menu
  end

  def self.add_comment(selection)
    comment = @@prompt.multiline("Enter your comments here:")
    ask = @@prompt.yes?('Would you recomment this event?', convert: :bool)
    x = Review.create(user_id: @user.id, event_id: selection,content: comment.join, recommend: ask)
    system "clear"
    puts "Thanks for your TicTalk!"
    main_menu
  end

  def self.view_comments(event)
    comment_list = Review.where('event_id =?', event.id)

    if comment_list == []
      puts "No TicTalk for this event yet."
      ticket_options(event)
    else
      list = comment_list.map do |comment|
      n = User.find(comment.user_id)
        rcm = if comment.recommend == true
          "Yes"
        else
          "No"
        end
      x = {}
      x[:name] = "Username: #{n.name}, Recommend?: #{rcm}\n TicTalk:\n #{comment.content}"
      x[:value] = comment.event_id
      x
    end
   end
    selection = @@prompt.select("Select a comment to return to event details:", list)
    ticket_options(event)
  end

  def self.view_comments_upcoming(event)
    comment_list = Review.where('event_id =?', event.id)

    if comment_list == []
      puts "No TicTalk for this event yet."
      ticket_options_upcoming(event)
    else
      list = comment_list.map do |comment|
      n = User.find(comment.user_id)
        rcm = if comment.recommend == true
          "Yes"
        else
          "No"
        end
      x = {}
      x[:name] = "Username: #{n.name}, Recommend?: #{rcm}\n TicTalk:\n #{comment.content}"
      x[:value] = comment.event_id
      x
    end
   end
    selection = @@prompt.select("Select a comment to return to event details:", list)
    system "clear"
    display_event(selection)
    ticket_options_upcoming(event)
  end


  def self.view_comments_past(event)
    comment_list = Review.where('event_id =?', event.id)

    if comment_list == []
      puts "No TicTalk for this event yet."
      ticket_options_past(event)
    else
      list = comment_list.map do |comment|
      n = User.find(comment.user_id)
        rcm = if comment.recommend == true
          "Yes"
        else
          "No"
        end
      x = {}
      x[:name] = "Username: #{n.name}, Recommend?: #{rcm}\n TicTalk:\n #{comment.content}"
      x[:value] = comment.event_id
      x
      end
    end
    selection = @@prompt.select("Select a comment to return to event details:", list)
    ticket_options_past(event)
  end

  def self.get_qty
    puts "How many tickets do you want?"
    qty = gets.chomp.to_i
    if qty > 10
      puts "No more than 10 tickets per purchase."
      get_qty
    end
    qty
  end


end
