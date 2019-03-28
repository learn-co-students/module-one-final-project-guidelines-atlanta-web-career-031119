module List

    @prompt = TTY::Prompt.new
    

    def print_monsters( monster)
    puts " "
    puts @pastel.red.bold(@doom.write("#{monster.name.upcase}"))
    if monster.danger_rating < 5
    puts @pastel.green.bold(@straight.write("Danger Rating: #{monster.danger_rating}"))
    elsif monster.danger_rating > 4 &&  monster.danger_rating < 9
        puts @pastel.yellow.bold(@straight.write("Danger Rating: #{monster.danger_rating}"))
    elsif monster.danger_rating >= 9
        puts @pastel.red.bold(@straight.write("Danger Rating: #{monster.danger_rating}!!!"))
    end
    puts " "
    puts "Location: #{monster.location}"
    puts " "
    puts "Description: #{monster.description}"
    puts "_" * 40
    puts "Total posts about #{monster.name}s: " + @pastel.cyan("#{monster.posts.length}")
    end

    def print_profile(user)
        puts @pastel.bold(@blocks.write("#{user.name}"))
        if user.monsters != nil
            user_rank(user)
        end
        puts "Rank: #{user.rank}"
        puts "Location: #{user.location}"
        puts "#{user.bio}"
        if user.monsters.length > 0
            monsters = user.monsters
            puts "Monsters encountered: " + @pastel.red.bold("#{monsters.pluck(:name).uniq.join(', ')}.")
        else
            puts "Monster encountered: 0"
        end
    end

    def print_posts(post)
        puts @pastel.green(" * ") * 20
        puts @pastel.bright_red.bold("Title: #{post.title}")
        puts "by "+ @pastel.cyan.bold("#{post.user.name}") +  " who encountered a " + @pastel.bold("#{post.monster.name}")
        puts " "
        puts "#{post.content}"
        puts " "
        puts "Likes " + @pastel.cyan.bold("#{num_of_likes(post)}")
        puts @pastel.green("-")*50
        like?(post)
        get_comments_for_post(post)
        end
    end

    def leave_comment?(post)
        comment = @prompt.yes?(@pastel.command('Would you like to leave a comment?'))
        if comment == true
            comment_on_post(post)
        end
    end
