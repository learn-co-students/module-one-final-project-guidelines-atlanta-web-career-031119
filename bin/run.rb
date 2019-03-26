require_relative '../config/environment'

# class CommandLineInterface

  def welcome
    font = TTY::Font.new(:standard)
    interpolated = font.write("Conquer College") #temp name

    puts "WELCOME TO"
    sleep(2)
    puts interpolated
    sleep(3)

    puts "Teachers usually provide a list of unnecessary school supplies for their upcoming class."
    sleep(2)

    puts "Here at Conquer College, students provide a realistic list of supplies you actually need."
    sleep(2)

    puts "Would you like to continue? Yes or No"

    user_input = gets.chomp
    if user_input == "Yes" || user_input == "YES" || user_input == "yes"
      main_menu
      sleep(5)
    else user_input == "No" || user_input == "NO" || user_input == "no"
      puts "Goodbye!"
    end
  end

  def main_menu
    puts "Main Menu"
    puts "View a list of all courses. (1)"
    puts "View your courses. (2)"
    puts "Add a course. (3)"
    puts "Find reviews for a course. (4)"
    puts "Update materials for a course. (5)"
    puts "View all materials for a grade. (6)"
    puts "See all users in a grade. (7)"

    user_input = gets.chomp
    if user_input == "1"
      all_courses
    elsif user_input == "2"
      your_course_menu
    elsif user_input == "3"
      add_course_menu
    elsif user_input == "4"
      find_reviews
    elsif user_input == "5"
      update_materials
    elsif user_input == "6"
      materials_for_grade
    elsif user_input == "7"
      all_users_in_x_grade
    end
  end

  def all_courses
    
  end

  def your_course_menu

  end

  def add_course_menu

  end

  def find_reviews
  end

  def update_materials

  end

  def materials_for_grade

  end

  def all_users_in_x_grade

  end

welcome
