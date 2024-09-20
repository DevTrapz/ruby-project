class Teacher < User
  has_many :courses
  has_many :students
end