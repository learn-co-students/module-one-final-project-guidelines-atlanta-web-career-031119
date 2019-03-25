class Event < ActiveRecord::Base
  has_many :tickets
  has_many :reviews
  has_many :users, through: :tickets 
end
