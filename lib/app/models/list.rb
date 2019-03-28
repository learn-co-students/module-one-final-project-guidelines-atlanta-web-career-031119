module List

    

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
        puts " * " * 20
        puts "Title: #{post.title}"
        puts " "
        puts "Posts: #{post.content}"
        puts "-"*50
    end
end