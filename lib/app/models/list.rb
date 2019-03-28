module List

    @prompt = TTY::Prompt.new
    

    def print_monsters( monster)
    puts " "
    puts @pastel.red.bold(@doom.write("#{monster.name.upcase}"))
    puts " "
    puts "Location: #{monster.location}"
    puts " "
    puts "Description: #{monster.description}"
    puts "_" * 40
    puts "Total posts about #{monster.name}s: " + @pastel.cyan("#{monster.posts.length}")
    end

    def print_profile(user)
        monsters = user.monsters
        puts @pastel.bold(@blocks.write("#{user.name}"))
        puts "Location: #{user.location}"
        puts "#{user.bio}"
        puts "Monsters encountered: " + @pastel.red.bold("#{monsters.pluck(:name).uniq.join(', ')}.")
    end

    def print_posts(post)
        puts @pastel.green(" * ") * 20
        puts @pastel.bright_red.bold("Title: #{post.title}")
        puts " "
        puts "#{post.content}"
        puts @pastel.green("-")*50
        get_comments_for_post(post)
        end
    end

    def leave_comment?(post)
        comment = @prompt.yes?(@pastel.command('Would you like to leave a comment?'))
        if comment == true
            comment_on_post(post)
        end
    end
