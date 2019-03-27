

def create_new_post
    prompt = TTY::Prompt.new
    title = prompt.ask("What would you like to call your new post?")
    content = prompt.ask("What would you like your new post to say?")
    monster_name = select_monster
    monster = Monster.find_by_name(monster_name)
    Post.create(user_id: @current_user.id, title: title, content: content, monster_id: monster.id)
end

def edit_post_selection(user)
    choices = []
    list = TTY::Prompt.new
    posts = user.posts
    posts.each do |post|
        choices << post.title
    end
    list.select("Which post would you like to edit?", choices)
end

def edit_post(post_to_edit)
   prompt = TTY::Prompt.new
   get_post_by_title(post_to_edit.title)
   to_edit = prompt.ask("What would you like the edited post to say?")
   post_to_edit.update(content: to_edit)
end

def select_monster
    choices = []
    monsters = get_all_monsters_names
    monsters.each do |mon|
        choices<< mon
    end
    prompt = TTY::Prompt.new
    prompt.select("Which cryptid would you like to tag for your post?", choices)
end

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

def print_posts_current_user(user)
    user.posts.each do |post|
        puts " * " * 20
        puts "Title: #{post.title}"
        puts " "
        puts "Posts: #{post.content}"
        puts "-"*50
        get_comments_for_post(post)
    end
end

def print_posts_by_user(selection)
    prompt = TTY::Prompt.new
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
    get_comments_for_post(post)
    comment = prompt.yes?('Would you like to leave a comment?')
        if comment == true
            comment_on_post(post)
            end
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


