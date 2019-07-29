
def welcome
    pastel = Pastel.new
    prompt = TTY::Prompt.new
    doom = TTY::Font.new(:doom)

puts pastel.red.bold(doom.write("Welcome to.......".upcase))
sleep(0.5)
puts pastel.bright_cyan (%(=================================================================================================))
sleep(0.1)
puts pastel.bright_magenta (%(     ______      ______    ___    ___   ______     ___________   ____________    _______    ))
sleep(0.1)
puts pastel.bright_magenta (%(   //  __  \\   ||   _  \\  \\\\  \\  /  / *||   _ \\  ||___    ___| ||___    ___ |  ||   __   \\  ))  
sleep(0.1)
puts pastel.bright_magenta (%(  //  /  \\__\\  ||  |  \\ |  \\\\  \\/  /   ||  | \\ |     ||  | *       ||  |       ||  |  \\   \\ ))
sleep(0.1)
puts pastel.bright_magenta (%( ||  |   *     ||  |__/ /   \\\\    /    ||  |_/ |     ||  |         ||  |    *  ||  |  |   |))
sleep(0.1)
puts pastel.bright_magenta (%( ||  |         ||  __  \\  *  ||  |     ||   __/   *  ||  |         ||  |       ||  |  | * |))
sleep(0.1)
puts pastel.bright_magenta (%( ||  |       * ||  | \\  \\    ||  |   * ||  |         ||  |       * ||  |       ||  |  |   |))
sleep(0.1)
puts pastel.bright_magenta (%( \\\\  \\     __  ||  |  \\  \\   ||  |     ||  |         ||  |         ||  |       ||  |  |   |))
sleep(0.1)
puts pastel.bright_magenta (%(  \\\\  \\__/  /  ||  |   \\  \\  ||  |     ||  |         ||  |   *  ___||  |___    ||  |__/  /)) 
sleep(0.1)
puts pastel.bright_magenta (%(   \\\\ _____/   ||__|  * \\__\\ ||__|     ||__|         ||__|     ||___________|  ||_______/))  
sleep(0.1)
puts pastel.bright_magenta (%(        ___    __    ___     __    ____      __   ___________    ________    _______))
sleep(0.1)
puts pastel.bright_magenta (%(       ||  |  |  |  ||  |   |  |  ||    \\ * |  | ||___    ___|  ||       |  ||   _   \\  * )) 
sleep(0.1)
puts pastel.bright_magenta (%(     * ||  |  |  |  ||  |   |  |  ||     \\  |  |     ||  |    * ||   ____|  ||  |  \\  |))
sleep(0.1)
puts pastel.bright_magenta (%(       ||  |__|  |  ||  |   |  |  ||      \\ |  |     ||  |      ||  |___    ||  |__/ / )) 
sleep(0.1)
puts pastel.bright_magenta (%(       ||   __   |  ||  | * |  |  ||  |\\    |  | *   ||  |      ||   ___|   ||  ___  \\ ))
sleep(0.1)
puts pastel.bright_magenta (%(       ||  |  |  |  ||  |   |  | *||  | \\      |     ||  |      ||  |   *   ||  |  \\  \\ )) 
sleep(0.1)
puts pastel.bright_magenta (%( *     ||  |  |  |  ||  |   |  |  ||  |  \\     |     ||  | *    ||  |____   ||  |   \\  \\ ))
sleep(0.1)
puts pastel.bright_magenta (%(       ||  |  |  |  \\\\  \\__/   /  ||  |   \\    |     ||  |      ||       |  ||  |  * \\  \\ ))
sleep(0.1)
puts pastel.bright_magenta (%(       ||__|  |__| * \\\\_______/   ||__|    \\___|     ||__|      ||_______|  ||__|     \\__\\ ))
sleep(0.1)
puts pastel.bright_cyan (%(=================================================================================================))
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
        user = User.find_by_name(result)
        if enter_password(user)
          puts "Welcome back, #{result}!"
          return user
        else 
          user_login
        end
      else
          puts "Hmmm, I don't see that name..."
          yes_or_no = prompt.yes?("Would you like to create an account?")
          if yes_or_no
            create_user(result)
          else
            user_login
        end
    end
end

def menu
    pastel = Pastel.new
    prompt = TTY::Prompt.new
    prompt.select("What would you like to do?") do |menu|
    menu.per_page 9
    menu.choice pastel.bright_green('Write a new post'), 1
    menu.choice pastel.bright_cyan('Edit a post'), 2
    menu.choice pastel.bright_magenta('Read posts'), 3
    menu.choice pastel.bright_yellow('Search for a monster'), 4
    menu.choice pastel.bright_yellow('Search for a specific user'), 5
    menu.choice pastel.bright_green('My profile'), 6
    menu.choice pastel.red('Exit'), 9
    end
end



def get_posts(user)
    user_name = User.find_by_name(user)
    posts = user.posts
    post.each do |post|
    puts pastel.bright_green("Title: #{posts.title}")
    puts "Posts: #{posts.content}"
    end
end

