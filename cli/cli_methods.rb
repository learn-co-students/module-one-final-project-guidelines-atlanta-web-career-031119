

def welcome
puts "Welcome to......."
sleep(0.5)
puts %(=================================================================================================)
sleep(0.1)
puts %(     ______      ______    ___    ___   ______     ___________   ____________    _______    )
sleep(0.1)
puts %(   //  __  \\   ||   _  \\  \\\\  \\  /  / *||   _ \\  ||___    ___| ||___    ___ |  ||   __   \\  )  
sleep(0.1)
puts %(  //  /  \\__\\  ||  |  \\ |  \\\\  \\/  /   ||  | \\ |     ||  | *       ||  |       ||  |  \\   \\ ) 
sleep(0.1)
puts %( ||  |   *     ||  |__/ /   \\\\    /    ||  |_/ |     ||  |         ||  |    *  ||  |  |   |)
sleep(0.1)
puts %( ||  |         ||  __  \\  *  ||  |     ||   __/   *  ||  |         ||  |       ||  |  | * |)
sleep(0.1)
puts %( ||  |       * ||  | \\  \\    ||  |   * ||  |         ||  |       * ||  |       ||  |  |   |)
sleep(0.1)
puts %( \\\\  \\     __  ||  |  \\  \\   ||  |     ||  |         ||  |         ||  |       ||  |  |   |)
sleep(0.1)
puts %(  \\\\  \\__/  /  ||  |   \\  \\  ||  |     ||  |         ||  |   *  ___||  |___    ||  |__/  /) 
sleep(0.1)
puts %(   \\\\ _____/   ||__|  * \\__\\ ||__|     ||__|         ||__|     ||___________|  ||_______/)  
sleep(0.1)
puts %(        ___    __    ___     __    ____      __   ___________    ________    _______)
sleep(0.1)
puts %(       ||  |  |  |  ||  |   |  |  ||    \\ * |  | ||___    ___|  ||       |  ||   _   \\  * ) 
sleep(0.1)
puts %(     * ||  |  |  |  ||  |   |  |  ||     \\  |  |     ||  |    * ||   ____|  ||  |  \\  |)
sleep(0.1)
puts %(       ||  |__|  |  ||  |   |  |  ||      \\ |  |     ||  |      ||  |___    ||  |__/ / ) 
sleep(0.1)
puts %(       ||   __   |  ||  | * |  |  ||  |\\    |  | *   ||  |      ||   ___|   ||  ___  \\ )
sleep(0.1)
puts %(       ||  |  |  |  ||  |   |  | *||  | \\      |     ||  |      ||  |   *   ||  |  \\  \\ ) 
sleep(0.1)
puts %( *     ||  |  |  |  ||  |   |  |  ||  |  \\     |     ||  | *    ||  |____   ||  |   \\  \\ )
sleep(0.1)
puts %(       ||  |  |  |  \\\\  \\__/   /  ||  |   \\    |     ||  |      ||       |  ||  |  * \\  \\ )
sleep(0.1)
puts %(       ||__|  |__| * \\\\_______/   ||__|    \\___|     ||__|      ||_______|  ||__|     \\__\\ )
sleep(0.1)
puts %(=================================================================================================)
end

def user_login
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    result = prompt.ask("What is your name?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        q.modify   :capitalize
      end
      if User.exists?(['name LIKE ?', "%#{result}%"])
       puts "Welcome back, #{result}!"
       return User.find_by_name(result)
      else
        puts "Hmmm, I don't see that name..."
        yes_or_no = prompt.yes?("Would you like to create an account?")
        if yes_or_no == true
            new_user = User.create(name: result)
            puts "Welcome to Cryptid Hunter " + pastel.red("#{result}!")
            new_user.location = prompt.ask("What city do you live in?")
            new_user.save
            return new_user
        end
    end
end

def menu
    prompt = TTY::Prompt.new
    prompt.select("What would you like to do?") do |menu|
    menu.choice 'Write a new post', 1
    menu.choice 'Edit a post', 2
    menu.choice 'Read posts', 3
    menu.choice 'Search for a monster', 4
    menu.choice 'Search for a specific user',5
    menu.choice 'exit', 6
    end
end



def get_posts(user)
    # prints posts from logged in user
end

def edit_post
    # allows logged in user to edit a post they own
end

def delete_post
    # allows user to delete a post they own
end

def get_comments_on_posts
    #prints comments on posts owned by user
end

def comment
    # adds a comment to a post
end

##Users ------------------------------------------
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
# Monsters ---------------------------------------
def get_all_monsters_names
    Monster.pluck(:name) 
end

def search_monsters_by_name
    choices = []
    monsters = get_all_monsters_names
    monsters.each do |mon|
        choices<< mon
    end
    prompt = TTY::Prompt.new
    prompt.select("Which cryptid would you like to know more about?", choices)
end

def get_monster_by_name(selection)
    monster = Monster.find_by_name(selection)
    puts " "
    puts "Name: #{monster.name}"
    puts " "
    puts "Location: #{monster.location}"
    puts " "
    puts "Description: #{monster.description}"
    puts "_" * 40
    puts "Total posts about #{monster.name}s " 
    end






    