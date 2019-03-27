@pastel = Pastel.new

def comment_on_post(post)
    prompt = TTY::Prompt.new
    comment = prompt.ask("What would you like to say?")
    user = @current_user
    Comment.create(user_id: user.id, post_id: post.id, content: comment)
end

def get_comments_for_post(post)
    comments = post.comments
    comments.each do |comment|
        puts @pastel.bold("#{comment.user.name} says: ") + "#{comment.content}"
        puts @pastel.green("_") * 50
    end
end

def comments_for_user(user)
    posts = user.posts
    posts.each do |post|
        puts "#{post.title}"
        get_comments_for_post(post)
    end
end
