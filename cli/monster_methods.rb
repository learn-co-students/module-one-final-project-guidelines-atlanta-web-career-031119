@doom = TTY::Font.new(:doom)
@straight = TTY::Font.new(:straight)
@pastel = Pastel.new
@pastel.alias_color(:command, :red, :bold)
@prompt = TTY::Prompt.new

include List

def get_all_monsters_names
    Monster.pluck(:name) 
end

def search_monsters_by_name
    choices = []
    monsters = get_all_monsters_names
    monsters.each do |mon|
        choices<< mon
    end
    @prompt.select(@pastel.command(@straight.write("Which cryptid would you like to know more about?")), choices)
end

def get_monster_by_name(selection)
    monster = Monster.find_by_name(selection)
    print_monsters(monster)
    return selection
    end

def get_monster_info?(selection)
    answer =  @prompt.yes?(@pastel.red.bold('Would you like to see posts about this type of monster?'))
end


def select_monster
    choices = []
    selection = nil
    monsters = get_all_monsters_names
    monsters.each do |mon|
        choices << mon
    end
    choices << "other"
    answer = @prompt.select(@pastel.command(@straight.write("Which cryptid would you like to tag for your post?")), choices)
    if answer == "other"
        name = @prompt.ask(@pastel.command("What is the name of this cryptid?"))
        monster_exists?(name) ? selection = create_new_monster(name) : selection = select_monster
        return selection
    else
        return answer
    end
end

def monster_exists?(name)
    if Monster.exists?(['name LIKE ?', "#{name}"]) == true
        puts @pastel.red("That cryptid already has an entry.")
    else
        return name
    end
end

def create_new_monster(name)
    description = "No one has submitted a description of this cryptid yet."
    location = @prompt.ask(@pastel.command("Where did you see this cryptid?"))
    description = @prompt.ask(@pastel.command("Would you like to submit a description for this cryptid?"))
    new_monster = Monster.create(name: name, location: location, description: description)
    new_monster.save
    new_monster.name
end