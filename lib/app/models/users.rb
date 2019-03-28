class User < ActiveRecord::Base
    
    include ActiveModel::Validations
    has_many :posts
    has_many :comments
    has_many :monsters, through: :posts
    has_many :likes, through: :posts

    validates :bio, length: { maximum: 5000,
    too_long: "%{count} characters is the maximum allowed" }
    
end  