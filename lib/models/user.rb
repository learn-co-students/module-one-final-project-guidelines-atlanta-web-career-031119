class User < ActiveRecord::Base
  has_many :subjects 
  belongs_to :grade
end
