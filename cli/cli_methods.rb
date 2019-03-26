

def welcome
puts "Welcome to......."
sleep(1)
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
      else
        puts "Hmmm, I don't see that name..."
        yes_or_no = prompt.yes?("Would you like to create an account?")
        if yes_or_no == true
            new_user = User.create(name: result)
            puts "Welcome to Cryptid Hunter " + pastel.red("#{result}!")
            new_user.location = prompt.ask("What city do you live in?")
            new_user.save
            binding.pry
        end
    end
end

def menu
    # lists options
    # create post
    # read posts
    # edit post
    # search for a monster
    #search for a user
    #help -display this list
    #exit app
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



    