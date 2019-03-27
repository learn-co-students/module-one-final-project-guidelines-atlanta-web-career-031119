require_relative '../config/environment'
require 'pry'

class CommandLineInterface

  def welcome
    font = TTY::Font.new(:standard)
    interpolated = font.write("Conquer College")

    puts "WELCOME TO"
    sleep(2)
    puts interpolated
    sleep(3)

    puts "Teachers often provide a list of suggested school supplies you'll need for their class."
    sleep(2)

    puts "Here at Conquer College, find out what supplies you'll actually need based from actual students."
    sleep(2)

    puts "Would you like to continue? Yes or No"

    user_input = gets.chomp
    if user_input == "Yes" || user_input == "YES" || user_input == "yes"
      user_login
      sleep(1)
    else user_input == "No" || user_input == "NO" || user_input == "no"
      puts "Goodbye!"
    end
  end

  def user_login
    puts "Please enter your name"
    name = gets.chomp
    puts "Select your grade from the following options:\nFreshman   Sophomore   Junior   Senior"
    grade = gets.chomp
    puts "Please enter your age"
    age = gets.chomp
    @user = User.find_or_create_by(name: name, age: age, grade_id: Grade.all.sample.id)
    main_menu
  end

  def main_menu
    puts ""
    puts "Main Menu"
    puts "View a list of all courses. (1)"
    puts "View your courses. (2)"
    puts "Add a course. (3)"
    puts "Find reviews for a course. (4)"
    puts "Update materials needed for a course. (5)"
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
    Subject.all.map {|subject| subject.name}
  end

  # def your_course_menu
  #   Subject.all.map {|subject| subject.name == self}
  # end
  #
  # def add_course_menu
  #
  # end
  #
  # def find_reviews
  # end

  def update_materials
    puts "Please enter the name of the supply you would like to update:"
    name = gets.chomp
    puts "Please enter the subject for the supply:"
    subject = gets.chomp
    @material = Material.find_or_create_by(name: name, subject_id: Subject.all.sample.id)
    main_menu
  end

  def materials_for_grade
    Material.all
  end

  def all_users_in_x_grade(grade)
    User.all.select {|user| user.grade_id == grade}
  end

end

begin_app = CommandLineInterface.new
begin_app.welcome
