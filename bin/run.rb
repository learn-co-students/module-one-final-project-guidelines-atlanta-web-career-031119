require_relative '../config/environment'


welcome
@current_user = user_login
menu_choice = nil
until menu_choice == 9 
    #------------MAIN MENU-------------#
menu_choice = menu

    #----------CREATE POST-----------#
    if menu_choice == 1
        create_new_post
    end

    #------------EDIT POST-----------#
    if menu_choice == 2
        selection = edit_post_selection(@current_user)
        post_to_edit = Post.find_by_title(selection)
        answer = delete_or_edit
        if answer == 1
            edit_post(post_to_edit)
        elsif answer == 2
            delete_post(post_to_edit)
        end
    end

    #------------READ POSTS MENU-------------#
if menu_choice == 3
    option = post_menu
    if option == 1
        selection = search_users_by_name
        print_posts_by_user(selection)
    end
    
    if option == 2
        answer = search_monsters_by_name 
        get_posts_about_monster(answer)
    end

    if option == 3
        title = get_most_recent_posts
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
    selection = user_sort_by_menu
        if selection == 1
            selection = search_users_by_name
            get_user_by_name(selection)
        elsif selection == 2
            name = search_users_by_rank
            get_user_by_name(name)
        elsif selection == 3
            name = search_users_by_popularity
        end

end

    #------------MY PROFILE MENU-------------#
if menu_choice == 6
    answer = profile_menu
        #view profile ADD USER MONSTERS OPTION
        if answer == 1
          selection = view_profile_menu
          if selection == 1
            get_user_profile(@current_user)
          elsif selection == 2
            print_posts_current_user(@current_user)
          elsif selection == 3
            comments_for_user(@current_user)
          end
        end 
        #edit profile
        if answer == 2
        option = update_profile_menu
        if option == 1
            update_location    
        elsif option == 2
            update_bio
        elsif option == 3
        end
    end
end



end

