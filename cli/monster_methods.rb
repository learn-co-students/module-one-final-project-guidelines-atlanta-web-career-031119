def get_all_monsters_names
    Monster.pluck(:name) 
end

def search_monsters_by_name
    choices = []
    monsters = get_all_monsters_names
    monsters.each do |mon|
        choices<< mon
    end
    prompt = TTY::Prompt.new
    prompt.select("Which cryptid would you like to know more about?", choices)
end

def get_monster_by_name(selection)
    monster = Monster.find_by_name(selection)
    puts " "
    puts "Name: #{monster.name}"
    puts " "
    puts "Location: #{monster.location}"
    puts " "
    puts "Description: #{monster.description}"
    puts "_" * 40
    puts "Total posts about #{monster.name}s " 
    return selection
    end

def get_monster_info?(selection)
    prompt = TTY::Prompt.new
    answer =  prompt.yes?('Would you like to see posts about this type of monster?')
end
       
