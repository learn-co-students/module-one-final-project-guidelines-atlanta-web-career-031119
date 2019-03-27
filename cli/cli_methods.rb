
  @pastel = Pastel.new
  @straight = TTY::Font.new(:straight)
  @blocks = TTY::Font.new(:standard)
  @doom = TTY::Font.new(:doom)

  @pastel.alias_color(:command, :red, :bold)
def welcome

puts @pastel.command(@straight.write("Welcome to......"))
sleep(0.5)
puts @pastel.bright_cyan(%(=================================================================================================))
sleep(0.1)
puts @pastel.bright_magenta.bold(%(     ______      ______    ___    ___   ______     ___________   ____________    _______    ))
sleep(0.1)
puts @pastel.bright_magenta.bold(%(   //  __  \\   ||   _  \\  \\\\  \\  /  / *||   _ \\  ||___    ___| ||___    ___ |  ||   __   \\  )  )
sleep(0.1)
puts @pastel.bright_magenta.bold(%(  //  /  \\__\\  ||  |  \\ |  \\\\  \\/  /   ||  | \\ |     ||  | *       ||  |       ||  |  \\   \\ ) )
sleep(0.1)
puts @pastel.bright_magenta.bold(%( ||  |   *     ||  |__/ /   \\\\    /    ||  |_/ |     ||  |         ||  |    *  ||  |  |   |))
sleep(0.1)
puts @pastel.bright_magenta.bold(%( ||  |         ||  __  \\  *  ||  |     ||   __/   *  ||  |         ||  |       ||  |  | * |))
sleep(0.1)
puts @pastel.bright_magenta.bold(%( ||  |       * ||  | \\  \\    ||  |   * ||  |         ||  |       * ||  |       ||  |  |   |))
sleep(0.1)
puts @pastel.bright_magenta.bold(%( \\\\  \\     __  ||  |  \\  \\   ||  |     ||  |         ||  |         ||  |       ||  |  |   |))
sleep(0.1)
puts @pastel.bright_magenta.bold(%(  \\\\  \\__/  /  ||  |   \\  \\  ||  |     ||  |         ||  |   *  ___||  |___    ||  |__/  /) )
sleep(0.1)
puts @pastel.bright_magenta.bold(%(   \\\\ _____/   ||__|  * \\__\\ ||__|     ||__|         ||__|     ||___________|  ||_______/)  )
sleep(0.1)
puts @pastel.bright_magenta.bold(%(        ___    __    ___     __    ____      __   ___________    ________    _______))
sleep(0.1)
puts @pastel.bright_magenta.bold(%(       ||  |  |  |  ||  |   |  |  ||    \\ * |  | ||___    ___|  ||       |  ||   _   \\  * ) )
sleep(0.1)
puts @pastel.bright_magenta.bold(%(     * ||  |  |  |  ||  |   |  |  ||     \\  |  |     ||  |    * ||   ____|  ||  |  \\  |))
sleep(0.1)
puts @pastel.bright_magenta.bold(%(       ||  |__|  |  ||  |   |  |  ||      \\ |  |     ||  |      ||  |___    ||  |__/ / ) )
sleep(0.1)
puts @pastel.bright_magenta.bold(%(       ||   __   |  ||  | * |  |  ||  |\\    |  | *   ||  |      ||   ___|   ||  ___  \\ ))
sleep(0.1)
puts @pastel.bright_magenta.bold(%(       ||  |  |  |  ||  |   |  | *||  | \\      |     ||  |      ||  |   *   ||  |  \\  \\ ) )
sleep(0.1)
puts @pastel.bright_magenta.bold(%( *     ||  |  |  |  ||  |   |  |  ||  |  \\     |     ||  | *    ||  |____   ||  |   \\  \\ ))
sleep(0.1)
puts @pastel.bright_magenta.bold(%(       ||  |  |  |  \\\\  \\__/   /  ||  |   \\    |     ||  |      ||       |  ||  |  * \\  \\ ))
sleep(0.1)
puts @pastel.bright_magenta.bold(%(       ||__|  |__| * \\\\_______/   ||__|    \\___|     ||__|      ||_______|  ||__|     \\__\\ ))
sleep(0.1)
puts @pastel.bright_cyan(%(=================================================================================================))
end

def user_login
    prompt = TTY::Prompt.new
    @pastel = Pastel.new
    result = prompt.ask("What is your name?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        q.modify   :capitalize
      end
      if User.exists?(['name LIKE ?', "%#{result}%"])
       puts @pastel.command(@straight.write("Welcome  back, #{result}!"))
       return User.find_by_name(result)
      else
        puts "Hmmm, I don't see that name..."
        yes_or_no = ("Would you like to create an account?")
        if yes_or_no == true
            new_user = User.create(name: result)
            puts "Welcome to Cryptid Hunter " + @pastel.red("#{result}!")
            new_user.location = prompt.ask("What city do you live in?")
            new_user.bio = prompt.ask("Tell us a little about yourself!")
            new_user.save
            return new_user
        end
    end
end

def menu
    prompt = TTY::Prompt.new
    prompt.select(@pastel.command(@straight.write("What would you like to do?"))) do |menu|
    menu.per_page 9
    menu.choice 'Write a new post', 1
    menu.choice 'Edit a post', 2
    menu.choice 'Read posts', 3
    menu.choice 'Search for a monster', 4
    menu.choice 'Search for a specific user',5
    menu.choice 'My profile', 6
    menu.choice @pastel.red('Exit'), 9
    end
end



def get_posts(user)
    user_name = User.find_by_name(user)
    posts = user.posts
    post.each do |post|
    puts "Title: #{posts.title}"
    puts "Posts: #{posts.content}"
    end
end

def delete_post(user)
    user_name = User.find_by_name(user)
    posts = user.posts
    posts.destroy
end

def get_comments_on_posts(user)
    up = get_posts(user)
    up.each do |posts|
    c = posts.comments
    c.each do |c|
    puts "#{c.name} says: #{c.content}"
    end
  end
end
