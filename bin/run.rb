require_relative '../config/environment'
require 'pry'

class CommandLineInterface

  def initialize
  @user = nil
  @schedule = []
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
      exit
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
    puts "View all courses offered for your grade level. (2)"
    puts "Add a course to the list of courses. (3)"
    puts "Add a course to your schedule. (4)"
    puts "View all materials for a course (5)"
    puts "Update materials needed for a course. (6)"
    puts "View all materials for a grade. (7)"
    puts "See all users in a grade. (8)"
    puts "Exit Application (9)."

    user_input = gets.chomp
    if user_input == "1"
      all_courses
    elsif user_input == "2"
      courses_for_your_grade
    elsif user_input == "3"
      add_course_menu
    elsif user_input == "4"
      add_course_to_schedule
    elsif user_input == "5"
      materials_for_course
    elsif user_input == "6"
      update_materials
    elsif user_input == "7"
      materials_for_grade
    elsif user_input == "8"
      all_users_in_x_grade
    else user_input == "9"
      exit
    end
  end

  def all_courses
    courses = Subject.all.map {|subject| subject.name}.sort.join(", ")
    puts "Here is a comprehensive list of all our courses: #{courses}"
    sleep(3)
    main_menu
  end

  def courses_for_your_grade
    puts " "
   if @user.grade.grade_level == 9
     puts Subject.all.where(grade_id: @user.grade_id).sort.map {|x| x.name}
     sleep (3)
     main_menu
   elsif @user.grade.grade_level == 10
     puts Subject.all.where(grade_id: @user.grade_id).sort.map {|x| x.name}
     sleep (3)
     main_menu
   elsif @user.grade.grade_level == 11
     puts Subject.all.where(grade_id: @user.grade_id).sort.map {|x| x.name}
     sleep (3)
     main_menu
   elsif @user.grade.grade_level == 12
     puts Subject.all.where(grade_id: @user.grade_id).sort.map {|x| x.name}
     sleep (3)
     main_menu
   end
  end

  def add_course_menu
    puts "Please enter the name of the course you want to add"
    name = gets.chomp
    Subject.create(name: name, grade_id: @user.grade_id)
    puts "You have added #{name} to the master course list!"
    main_menu
  end

  def add_course_to_schedule
    puts "Please choose a course to add to your schedule from the following options:"
    if @user.grade.grade_level == 9
      puts Subject.all.where(grade_id: @user.grade.id).sort.map {|x| x.name}
      sleep (1)
      user_input = gets.chomp
      @schedule << user_input
      my_schedule
    elsif @user.grade.grade_level == 10
      puts Subject.all.where(grade_id: @user.grade.id).sort.map {|x| x.name}
      sleep (1)
      user_input = gets.chomp
      @schedule << user_input
      my_schedule
    elsif @user.grade.grade_level == 11
      puts Subject.all.where(grade_id: @user.grade.id).sort.map {|x| x.name}
      sleep (1)
      user_input = gets.chomp
      @schedule << user_input
      my_schedule
    elsif @user.grade.grade_level == 12
      puts Subject.all.where(grade_id: @user.grade.id).sort.map {|x| x.name}
      sleep (1)
      user_input = gets.chomp
      @schedule << user_input
      my_schedule
    end
  end

  def my_schedule
    puts "Here are the following courses in your schedule:"
    puts @schedule
    main_menu
  end

  def materials_for_course
    puts "Which course?"
    course1 = gets.chomp
    subject2 = Subject.all.find{|x| x.name == course1}
    mats = subject2.materials
    name = mats.map {|x| x.name}.join(", ")
    puts "Here are the materials required for #{course1}: #{name}"
    sleep(2)
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
      # binding.pry
      puts "Please enter the subject to delete the material from:"
      course = gets.chomp
      puts "Here are all of the materials currently required for #{course}:"
      mats = Subject.all.find {|x| x.name == course}.materials.map {|x| x.name}.join(", ")
      puts mats
      sleep(1)
      puts "Please enter the name of the material you would like to delete for #{course}:"
      mat_name = gets.chomp
      Material.destroy(Subject.all.find {|x| x.name == course}.materials.where(name: mat_name)[0])
      main_menu
    end
  end

  def materials_for_grade #fix this method
    puts "Which grade?"
    grade = gets.chomp.to_i
    list_of_materials = Grade.all.find{|x| x.grade_level == grade}.subjects.map {|x| x.materials}.flatten.map {|x| x.name}.sort.join(", ")
    puts "The Materials for grade #{grade} are: #{list_of_materials}"
    main_menu
  end

  def all_users_in_x_grade
    puts "Which grade?"
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
