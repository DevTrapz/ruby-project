class User < ApplicationRecord
  # has_many :permissions
  # has_many :orders
  has_many :courses
  has_many :students
end
