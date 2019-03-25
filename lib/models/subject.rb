class Subject < ActiveRecord::Base
  has_many :materials
  belongs_to :grade
end
