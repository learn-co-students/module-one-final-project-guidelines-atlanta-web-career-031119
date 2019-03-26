require 'tty-prompt'

prompt = TTY::Prompt.new

def welcome_message
  puts "Welcome to TicTalk"
  name = prompt.ask("Please enter your name to continue:")
  if User.all include?(name: name)
    puts "Welcome back!"
  else
    User.new(name.to_s)
    puts "Nice to meet you!"
  end
end

welcome_message
