require_relative '../config/environment'
require 'pry'
require 'pastel'

class CommandLineInterface

  def initialize
  @user = nil
  @schedule = []
  @pastel = Pastel.new
  end


  def welcome
    pastel = Pastel.new
    font = TTY::Font.new(:standard)
    interpolated = font.write("School Scheduler")

    puts pastel.green("WELCOME TO")
    # sleep(2)
    puts interpolated
    # sleep(3)

    puts pastel.green("Be prepared for your first day of classes!")
    # sleep(2)

    puts pastel.green("Use School Scheduler to add classes to your schedule, find materials needed for your classes, and more!")
    # sleep(2)

    puts pastel.green("Would you like to continue? Yes or No")

    user_input = gets.chomp
    if user_input == "Yes" || user_input == "YES" || user_input == "yes"
      user_login
      sleep(1)
    else user_input == "No" || user_input == "NO" || user_input == "no"
      exit
    end
  end

  def user_login
    pastel = Pastel.new
    puts pastel.green("Please enter your name")
    name = gets.chomp
    puts pastel.green("Please enter your age")
    age = gets.chomp
    puts pastel.green ("Select your grade from the following options :\nFreshman   Sophomore   Junior   Senior")
    grade = gets.chomp
    if grade == "Freshman"
      found_grade_nine = Grade.find_by(grade_level: 9)
      @user = User.find_or_create_by(name: name, age: age, grade_id: found_grade_nine.id)
      sleep(2)
      main_menu
    elsif grade == "Sophomore"
      found_grade_ten = Grade.find_by(grade_level: 10)
      @user = User.find_or_create_by(name: name, age: age, grade_id: found_grade_ten.id)
      sleep(2)
      main_menu
    elsif grade == "Junior"
      found_grade_eleven = Grade.find_by(grade_level: 11)
      @user = User.find_or_create_by(name: name, age: age, grade_id: found_grade_eleven.id)
      sleep(2)
      main_menu
    elsif grade == "Senior"
      found_grade_twelve = Grade.find_by(grade_level: 12)
      @user = User.find_or_create_by(name: name, age: age, grade_id: found_grade_twelve.id)
      sleep(2)
      main_menu
    else
      puts "Sorry, that is not a valid grade. Please start over."
     user_login
    end
  end

  def main_menu
    pastel = Pastel.new

    puts ""
    puts pastel.green("MAIN MENU")
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "View my schedule. (1)"
    puts "Add a course to your schedule. (2)"
    puts "View all courses offered for your grade level. (3)"
    puts "View a list of all courses. (4)"
    puts "Add a course to the list of courses. (5)"
    puts "View all materials for a course. (6)"
    puts "Update materials needed for a course. (7)"
    puts "View all materials for a grade. (8)"
    puts "See all users in a grade. (9)"
    puts "Exit Application. (10)"

    user_input = gets.chomp
    if user_input == "1"
      my_schedule
    elsif user_input == "2"
      add_course_to_schedule
    elsif user_input == "3"
      courses_for_your_grade
    elsif user_input == "4"
      all_courses
    elsif user_input == "5"
      add_course_menu
    elsif user_input == "6"
      materials_for_course
    elsif user_input == "7"
      update_materials
    elsif user_input == "8"
      materials_for_grade
    elsif user_input == "9"
      all_users_in_x_grade
    elsif user_input == "10"
      exit
    else
      puts ""
      puts "Please select from one of these options:"
      puts ""
      main_menu
    end
  end

  def all_courses

    courses = Subject.all.map {|subject| subject.name}.sort.join(", ")
    pastel_courses = @pastel.decorate(courses, :red, :on_black, :bold)
    puts "Here is a comprehensive list of all our courses: #{pastel_courses}"
    sleep(3)
    main_menu
  end

  def courses_for_your_grade
    sub = Subject.all.where(grade_id: @user.grade_id).sort.map {|x| x.name}.sort.join(", ")
    pastel = @pastel.decorate(sub, :red, :on_black, :bold)
    puts " "
    sleep (3)
    puts pastel
    main_menu
  end

  def add_course_menu
    puts "Please enter the name of the course you want to add"
    name = gets.chomp
    Subject.create(name: name, grade_id: @user.grade_id)
    sleep(3)
    puts "You have added #{name} to the master course list!"
    main_menu
  end

  def add_course_to_schedule
    puts "Please choose a course to add to your schedule from the following options:"
    puts Subject.all.where(grade_id: @user.grade.id).sort.map {|x| x.name}
    user_input = gets.chomp
    find_sub = Subject.all.find_by(name: user_input).name
    user_input == find_sub
    sleep (1)
    @schedule << user_input
    sleep(3)
    my_schedule
  end

  def my_schedule
    puts "Here are the following courses in your schedule:"
    string = @schedule.join (", ")
    puts @pastel.decorate(string, :red, :on_black, :bold)
    main_menu
  end

  def materials_for_course
    puts "Which course?"
    course1 = gets.chomp
    subject2 = Subject.all.find{|x| x.name == course1}
    mats = subject2.materials
    name = mats.map {|x| x.name}.join(", ")
    pastel = @pastel.decorate(name, :magenta, :on_black, :bold)
    puts "Here are the materials required for #{course1}: #{pastel}"
    sleep(3)
    main_menu
  end

  def update_materials
    puts "Would you like to add or delete a material required for a course?"
    puts "Type add or delete"
    user_input = gets.chomp
    if user_input == "add" || user_input == "Add"
      puts "Please enter the name of the supply you would like to add:"
      name = gets.chomp
      puts "Please enter the subject for the supply:"
      course = gets.chomp
      match = Subject.all.find {|x| x.name == course}
      @material = Material.find_or_create_by(name: name, subject_id: match.id)
      puts "Thanks for adding #{name.downcase} as a material required for #{course}."
      main_menu
    elsif user_input == "delete" || user_input == "Delete"
      puts "Please enter the subject to delete the material from:"
      course = gets.chomp
      puts "Here are all of the materials currently required for #{course}:"
      mats = Subject.all.find {|x| x.name == course}.materials.map {|x| x.name}.join(", ")
      pastel = @pastel.decorate(mats, :magenta, :on_black, :bold)
      puts pastel
      sleep(1)
      puts "Please enter the name of the material you would like to delete for #{course}:"
      mat_name = gets.chomp
      Material.destroy(Subject.all.find {|x| x.name == course}.materials.where(name: mat_name)[0])
      main_menu
    end
  end

  def materials_for_grade
    puts "Which grade?"
    puts "Please enter one: 9   10   11   12"
    grade = gets.chomp.to_i
    list_of_materials = Grade.all.find{|x| x.grade_level == grade}.subjects.map {|x| x.materials}.flatten.map {|x| x.name}.sort.join(", ")
    puts "The Materials for grade #{grade} are:"
    puts "#{list_of_materials}"
    main_menu
  end

  def all_users_in_x_grade
    puts "Which grade?"
    puts "Please enter one: 9   10   11   12"
    grade = gets.chomp.to_i
    users =  Grade.all.find {|x| x.grade_level == grade}.users.map {|x| x.name}.join (", ")
    puts "The Users for grade #{grade} are: #{users}"
    main_menu
  end

  def exit
  puts "GOOD BYE"
  end

end

begin_app = CommandLineInterface.new
begin_app.welcome
