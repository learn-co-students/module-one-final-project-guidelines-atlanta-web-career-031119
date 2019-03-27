require_relative '../config/environment'
require 'pry'

class CommandLineInterface

def initialize
@user = nil
end


  def welcome
    font = TTY::Font.new(:standard)
    interpolated = font.write("Conquer College")

    puts "WELCOME TO"
    # sleep(2)
    puts interpolated
    # sleep(3)

    puts "Teachers often provide a list of suggested school supplies you'll need for their class."
    # sleep(2)

    puts "Here at Conquer College, find out what supplies you'll actually need based from actual students."
    # sleep(2)

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
    puts "Please enter your age"
    age = gets.chomp
    puts "Select your grade from the following options:\nFreshman   Sophomore   Junior   Senior"
    grade = gets.chomp
    if grade == "Freshman"
      found_grade_nine = Grade.find_by(grade_level: 9)
      @user = User.find_or_create_by(name: name, age: age, grade_id: found_grade_nine.id)
      main_menu
    elsif grade == "Sophomore"
      found_grade_ten = Grade.find_by(grade_level: 10)
      @user = User.find_or_create_by(name: name, age: age, grade_id: found_grade_ten.id)
      main_menu
    elsif grade == "Junior"
      found_grade_eleven = Grade.find_by(grade_level: 11)
      @user = User.find_or_create_by(name: name, age: age, grade_id: found_grade_eleven.id)
      main_menu
    elsif grade == "Senior"
      found_grade_twelve = Grade.find_by(grade_level: 12)
      @user = User.find_or_create_by(name: name, age: age, grade_id: found_grade_twelve.id)
      main_menu
    else
      puts "please enter your grade"
    end
  end

  def main_menu
    puts ""
    puts "Main Menu"
    puts "View a list of all courses. (1)"
    puts "View your courses. (2)"
    puts "Add a course. (3)"
    puts "View all materials for a course (4)"
    puts "Update materials needed for a course. (5)"
    puts "View all materials for a grade. (6)"
    puts "See all users in a grade. (7)"
    puts "Exit Application (8)."

    user_input = gets.chomp
    if user_input == "1"
      all_courses
    elsif user_input == "2"
      your_course_menu
    elsif user_input == "3"
      add_course_menu
    elsif user_input == "4"
      materials_for_course
    elsif user_input == "5"
      update_materials
    elsif user_input == "6"
      materials_for_grade
    elsif user_input == "7"
      all_users_in_x_grade
    else user_input == "8"
      exit
    end
  end

  def all_courses
    courses = Subject.all.map {|subject| subject.name}
    puts "Here is a comprehensive list of all our courses: #{courses}"
    main_menu
  end

  def your_course_menu
    my_subjects = @user.grade.subjects
    puts "Your courses are : #{my_subjects}"
    main_menu
  end

  def add_course_menu
    puts "Please enter the name of the course you want to add"
    name = gets.chomp
    Subject.create(name: name, grade_id: @user.grade_id)
    puts "You have added #{name} to your course list!"
    main_menu
  end

  def materials_for_course
    puts "Which course?"
    course1 = gets.chomp
    subject2 = Subject.all.find{|x| x.name == course1}
    mats = subject2.materials
    name = mats.map {|x| x.name}.join(" ")
    puts "The Materials for grade #{course1} are: #{name}"
    main_menu
  end

  def update_materials
    puts "Please enter the name of the supply you would like to update:"
    name = gets.chomp
    puts "Please enter the subject for the supply:"
    subject = gets.chomp
    @material = Material.find_or_create_by(name: name, subject_id: Subject.all.sample.id)
    main_menu
  end

  def materials_for_grade
    puts "Which grade?"
    grade = gets.chomp.to_i
    list_of_materials = Grade.all.find{|x| x.grade_level == grade}.subjects.map {|x| x.materials}[0]
    one_array = list_of_materials.map {|x| x.name}.join(" ")
    each_item = one_array
    puts "The Materials for grade #{grade} are: #{one_array}"
    main_menu
  end

  def all_users_in_x_grade
    puts "Which grade?"
    grade = gets.chomp.to_i
    users =  Grade.all.find {|x| x.grade_level == grade}.users.map {|x| x.name}.join (" ")
    puts "The Users for grade #{grade} are: #{users}"
    main_menu
  end

  def exit
  puts "GOOD BYE"
  end

end

begin_app = CommandLineInterface.new
begin_app.welcome
