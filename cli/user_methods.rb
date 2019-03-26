def get_users_names
    User.pluck(:name)
end

def search_users_by_name
    choices = []
    users = get_users_names
    users.each do |user|
        choices << user
    end
    prompt = TTY::Prompt.new
    prompt.select("Which user are you looking for?", choices)
end

def get_user_by_name(selection)
    user = User.find_by_name(selection)
    monsters = user.monsters
    puts "Name: #{user.name}"
    puts "Location: #{user.location}"
    puts "#{user.bio}"
    puts "Monsters encountered: #{monsters.pluck(:name).join(', ')}."
end


def user_monsters(user)
monsters = user.monsters 
monsters.each do |mon|
    puts " * " * 25
    puts " "
    puts "Name: #{mon.name}"
    puts " "
    puts "Location: #{mon.location}"
    puts " "
    puts "Description: #{mon.description}"
    puts "_" * 40
    puts "Total posts about #{mon.name}s " 
    end
end

def profile_menu
    profile = TTY::Prompt.new
    profile.select("What would you like to do?") do |menu|
        menu.choice "View my profile", 1
        menu.choice "Edit my profile", 2
    end
end

def update_profile_menu
    update_menu = TTY::Prompt.new
    update_menu.select("Okay! What woud you like to change?") do |menu|
        menu.choice "Edit Location", 1
        menu.choice "Edit Bio", 2
    end
end

def update_location
    user = @current_user
    prompt = TTY::Prompt.new
    new_location= prompt.ask("What is your new location?")
    user.update(location: new_location)
    puts "Okay! We'll change your location to #{new_location}"
    sleep(1)
end

def update_bio
    user = @current_user
    prompt = TTY::Prompt.new
    new_bio = prompt.ask("What would you like your new bio to say?")
    user.update(bio: new_bio)
    puts "Okay! You're bio has been updated!"
    sleep(1)
end


