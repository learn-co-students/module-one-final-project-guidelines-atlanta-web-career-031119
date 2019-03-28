
def like?(post)
   if Like.find_by_user_id_and_post_id(@current_user.id, post.id) == nil
    prompt = TTY::Prompt.new
    answer =prompt.yes?("Do you want to like this post?")
        if answer == true
            user = @current_user 
            Like.create(user_id: user.id, post_id: post.id)
        end 
    end
end 

def num_of_likes(post)
    post.likes.count
end

