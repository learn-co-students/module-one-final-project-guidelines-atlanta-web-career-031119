def likes(user)
    prompt = TTY::Prompt.new
    puts prompt.yes?("Do you want to like this post?")
        if prompt == true
            Like.create(user_id: user_id, post_id: post_id)
        end 
end 

