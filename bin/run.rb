require_relative '../config/environment'

# font = TTY::Font.new(:standard)
# puts font.write("HELLO WORLD")

# class CommandLineInterface

  def welcome
    font = TTY::Font.new(:standard)
    interpolated = font.write("SCHOOL SUPPLIES") #temp name

    puts "WELCOME TO"
    sleep(2)
    puts interpolated
    sleep(3)

    puts "Teachers usually provide a list of unnecessary school supplies for their upcoming class."
    sleep(1)

    puts "Here at School Supplies, students provide a realistic list of supplies you actually need."
    sleep(1)

    puts "Would you like to continue? Yes or No"

    user_input = gets.chomp
    if user_input == "Yes" || user_input == "YES" || user_input == "yes"
      main_menu
    else user_input == "No" || user_input == "NO" || user_input == "no"
      puts "Goodbye!"
    end
  end

  def main_menu
    
  end

welcome
