class Post < ActiveRecord::Base
    belongs_to :user
    belongs_to :monster
    has_many :comments
    has_many :likes 
end 