
@pastel = Pastel.new
@straight = TTY::Font.new(:straight)
@blocks = TTY::Font.new(:standard)
@doom = TTY::Font.new(:doom)

@pastel.alias_color(:border, :green)
@pastel.alias_color(:title, :bright_red, :bold)
@pastel.alias_color(:command, :red, :bold)

include List

def create_new_post
    prompt = TTY::Prompt.new
    title = prompt.ask(@pastel.command("What would you like to call your new post?")) do |q|
            q.required true
            end
    content = prompt.ask(@pastel.command("What would you like your new post to say?")) do |q|
              q.required true
            end
    monster_name = select_monster
    monster = Monster.find_by_name(monster_name)
    Post.create(user_id: @current_user.id, title: title, content: content, monster_id: monster.id)
end

def delete_or_edit
    list = TTY::Prompt.new
    list.select(@pastel.command(@straight.write("Would you like to edit or delete this post?"))) do |menu|
        menu.choice "Edit post", 1
        menu.choice "Delete post", 2
    end
end

def delete_post(post_to_edit)
    prompt = TTY::Prompt.new()
    answer = prompt.yes?(@pastel.command(@straight.write("Are you sure you want to delete this post")))
    if answer == true
        post_to_edit.destroy
    end
 end

def edit_post_selection(user)
    choices = []
    list = TTY::Prompt.new
    posts = user.posts
    posts.each do |post|
        choices << post.title
    end
    list.select(@pastel.command(@straight.write("Which post would you like to edit?")), choices)
end

def edit_post(post_to_edit)
   prompt = TTY::Prompt.new
   get_post_by_title(post_to_edit.title)
   to_edit = prompt.ask("What would you like the edited post to say?")
   post_to_edit.update(content: to_edit)
end

def post_menu
    posts_menu = TTY::Prompt.new
    posts_menu.select(@pastel.command(@straight.write("How would you like to search posts?"))) do |menu|
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
        print_posts(post)
        get_comments_for_post(post)
    end
end

def print_posts_by_user(selection)
    prompt = TTY::Prompt.new
    posts = get_posts_by_user(selection)
    user = User.find_by_name(selection)
    if posts == []
        puts @pastel.command(@straight.write("Oops! It looks like #{user.name} hasn't posted anything yet!"))
    else
    posts.each do |post|
    print_posts(post)
    get_comments_for_post(post)
    comment = prompt.yes?(@pastel.command('Would you like to leave a comment?'))
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
        print_posts(post)
        comment_on_post(post)
    end
end

def get_post_by_title(title)
    post = Post.find_by_title(title)
    print_posts(post)
    comment_on_post(post)
end



def get_most_recent_posts
    posts = Post.all.order('created_at DESC')
    choices = []
    list = TTY::Prompt.new
    posts.each do |post|
        choices << post.title
    end
    list.select(@pastel.command(@straight.write("Which post would you like to read?")), choices)
end

def list_posts(user)
    choices = []
    list = TTY::Prompt.new
    posts = user.posts
    posts.each do |post|
        choices << post.title
    end
    list.select(@pastel.command(@straight.write("Which post would you like to delete?")), choices)
end
