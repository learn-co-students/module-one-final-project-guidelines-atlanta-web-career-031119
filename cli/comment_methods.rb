def comment_on_post(post)
    prompt = TTY::Prompt.new
    comment = prompt.ask("What would you like to say?")
    user = @current_user
    Comment.create(user_id: user.id, post_id: post.id, content: comment)
end

def get_comments_for_post(post)
    comments = post.comments
    comments.each do |comment|
        puts "#{comment.user.name} says: #{comment.content}"
        puts "_" * 50
    end
end
