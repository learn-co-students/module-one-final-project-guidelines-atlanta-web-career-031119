@pastel = Pastel.new
@blocks = TTY::Font.new(:standard)

include List

def get_users_names
    User.pluck(:name)
end

def user_sort_by_menu
    prompt = TTY::Prompt.new
    selection = prompt.select("How would you like to sort users?") do |menu|
        menu.choice 'By Name', 1
        menu.choice 'By Rank', 2
    end
end

def search_users_by_name
    choices = []
    users = get_users_names
    users.each do |user|
        choices << user
    end
    choices = choices.sort
    prompt = TTY::Prompt.new
    prompt.select("Which user are you looking for?", choices)
end

def search_users_by_rank
    choices = []
    user_by_rank = User.all.order('rank DESC')
    user_by_rank.each do |user|
        choices << user.name
    end
    prompt = TTY::Prompt.new
    prompt.select("Which user are you looking for?", choices)
end

def get_user_profile(user)
    print_profile(user)
end

def get_user_by_name(selection)
    user = User.find_by_name(selection)
    print_profile(user)
end


def user_monsters(user)
monsters = user.monsters 
monsters.each do |mon|
print_monsters(mon)
    end
end

def profile_menu
    profile = TTY::Prompt.new
    profile.select("What would you like to do?") do |menu|
        menu.choice "View my profile", 1
        menu.choice "Edit my profile", 2
    end
end

def view_profile_menu
    view_menu = TTY::Prompt.new
    view_menu.select("What would you like to see?") do |menu|
        menu.choice "Profile", 1
        menu.choice "My posts", 2
        menu.choice "Comments on my posts", 3
    end
end


def update_profile_menu
    update_menu = TTY::Prompt.new
    update_menu.select("Okay! What woud you like to change?") do |menu|
        menu.choice "Edit Location", 1
        menu.choice "Edit Bio", 2
        menu.choice "Nevermind", 3
    end
end

def update_location
    user = @current_user
    prompt = TTY::Prompt.new
    new_location = prompt.ask("What is your new location?")
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


def user_rank(user)
    if user.monsters == nil || user.posts == nil
        user.rank = 0
    else
    monster_rank = user.monsters.map {|monster| monster.danger_rating }
    user_posts = user.posts.length
    user.update(rank: (monster_rank.inject(0){|sum, x| sum + x} + user_posts))
    end
end

def create_password(new_user)
    new_user.password = @prompt.mask("Please enter a password", required: true)
    password = @prompt.mask("Please enter password again", required: true)
    if new_user.authenticate(password)
    return
    elsif new_user.authenticate(password) == false
    puts "Password did not match"
    create_password(new_user)
    end
end

def enter_password(user)
    password = @prompt.mask("Password:")
    if user.authenticate(password)
        return true
    else
    puts "incorrect password"
    return false
    end
end

def create_user(result)
    new_user = User.create(name: result, rank: 0)
            puts "Welcome to Cryptid Hunter " + @pastel.red("#{result}!")
            create_password(new_user)
            new_user.location = @prompt.ask("What city do you live in?")
            new_user.bio = @prompt.ask("Tell us a little about yourself!")
            new_user.save
            new_user
end

