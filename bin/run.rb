require_relative '../config/environment'


welcome
@current_user = user_login
menu_choice = nil
until menu_choice == 9 
    #------------MAIN MENU-------------#
menu_choice = menu


    #------------READ POSTS MENU-------------#
if menu_choice == 3
    option = post_menu
    if option == 1
        selection = search_users_by_name
        print_posts_by_user(selection)
    end
    
    if option == 2
        answer = search_monsters_by_name 
        get_posts_about_monster(selection)
    end

    if option == 3
        get_most_recent_posts
        title = list_posts
        get_post_by_title(title)
    end
end

    #------------SEARCH FOR A MONSTER MENU-------------#
if menu_choice == 4
selection = search_monsters_by_name
get_monster_by_name(selection)
answer = get_monster_info?(selection)
if answer == true
get_posts_about_monster(selection)
end
end


    #------------SEARCH FOR A USER MENU-------------#
if menu_choice == 5
    selection = search_users_by_name
    get_user_by_name(selection)
end

    #------------EDIT PROFILE MENU-------------#
if menu_choice == 6
    answer = profile_menu
        if answer == 2
        option = update_profile_menu
        if option == 1
            update_location    
        elsif option == 2
            update_bio
        end
    end
end



end

