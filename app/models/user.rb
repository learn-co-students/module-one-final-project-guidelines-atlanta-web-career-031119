class User < ActiveRecord::Base
    validates :name, length: { in: 6..16 }
end