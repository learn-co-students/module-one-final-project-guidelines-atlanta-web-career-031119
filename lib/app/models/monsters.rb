class Monster < ActiveRecord::Base
    has_many :comments, through: :posts
    has_many :users, through: :posts
end 
