require_relative '../config/environment'
require_relative '../cli/cli_methods'

welcome
current_user = user_login
menu_choice = nil
until menu_choice == 6 
menu_choice = menu

# if menu_choice == 3
#     get_posts
# end

if menu_choice == 5
    selection = search_users_by_name
    get_user_by_name(selection)
end

if menu_choice == 4
selection = search_monsters_by_name
get_monster_by_name(selection)
prompt = TTY::Prompt.new
if prompt.yes?('Would you like to see posts about this type of monster?') == true
    Monster.find_by_name(selection).posts
end
end

end

