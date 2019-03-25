require 'bundler'
require 'pry'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

<<<<<<< HEAD
binding.pry
=======

>>>>>>> 98cbea4d1655905b9fc9140131e2e03f39e16532
