def post_menu
    posts_menu = TTY::Prompt.new
    posts_menu.select("Okay! How would you like to search posts?") do |menu|
        menu.choice "By User", 1
        menu.choice "By Monster", 2
        menu.choice "Most Recent", 3
    end
end

def get_posts_by_user(selection)
    user = User.find_by_name(selection)
    posts = user.posts
end

def print_posts_by_user(selection)
    posts = get_posts_by_user(selection)
    user = User.find_by_name(selection)
    if posts == []
        puts "Oops! It looks like #{user.name} hasn't posted anything yet!"
    else
    posts.each do |post|
    puts " * " * 20
    puts "Title: #{post.title}"
    puts " "
    puts "Posts: #{post.content}"
    puts "-"*50
        end
    end
 end

 def get_posts_about_monster(selection)
    monster = Monster.find_by_name(selection)
    posts = monster.posts
    posts.each do |post|
        puts " * " * 20
        puts "Title: #{post.title}"
        puts " "
        puts "Posts: #{post.content}"
        puts "-"*50
    end
end

def get_post_by_title(title)
    post = Post.find_by_title(title)
    puts " * " * 20
    puts "Title: #{post.title}"
    puts " "
    puts "Posts: #{post.content}"
    puts "-"*50
end



def get_most_recent_posts
    posts = Post.all.order('created_at DESC')
end

def list_posts
    choices = []
    list = TTY::Prompt.new
    posts = get_most_recent_posts
    posts.each do |post|
        choices << post.title
    end
    list.select("Which post would you like to read?", choices)
end


