class User < ActiveRecord::Base

    has_secure_password
    
    include ActiveModel::Validations
    has_many :posts
    has_many :comments
    has_many :monsters, through: :posts
    has_many :likes

    has_secure_password 

    validates :bio, length: { maximum: 5000,
    too_long: "%{count} characters is the maximum allowed" }
    
end  