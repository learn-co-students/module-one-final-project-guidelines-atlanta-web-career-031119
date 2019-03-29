require 'bundler'
require 'launchy'
# gem install launchy
# require 'rest-client'
# require 'json'
# require 'pry'
# tmdb api key: 84183c2fcf1dbb47fba4426356bb766c
# omdb api key: 92d4118f


Bundler.require

ActiveSupport::Deprecation.silenced = true
ActiveSupport::Deprecation.behavior = :silence
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil
require_all 'app'
