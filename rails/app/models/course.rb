class Course < ApplicationRecord
  belongs_to :teacher
  has_many :schoology_records
  has_many :students, through: :schoology_records
end
