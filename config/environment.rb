require 'bundler/setup'
require 'pry'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
ActiveRecord::Base.logger = nil


require_relative '../cli/cli_methods'
require_relative '../cli/user_methods'
require_relative '../cli/monster_methods'
require_relative '../cli/posts_methods'
require_relative '../cli/comment_methods'

