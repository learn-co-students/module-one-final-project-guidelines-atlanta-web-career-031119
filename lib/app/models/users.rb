class User < ActiveRecord::Base

    include ActiveModel::Validations
    has_many :posts
    has_many :comments
    has_many :monsters, through: :posts

end  