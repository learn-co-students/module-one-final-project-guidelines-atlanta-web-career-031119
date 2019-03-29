class Monster < ActiveRecord::Base
    has_many :posts
    include List
end 
