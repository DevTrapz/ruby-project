class Student < ApplicationRecord
  belongs_to :teacher
  has_many :schoology_records
  has_many :courses, through: :schoology_records

  def self.find_or_create_from_csv filename, teacher
    require 'csv'
    user_headers = {
        first_name: "First Name",
        last_name: "Last Name",
        lauid: "Unique User ID",
        username: "Username"
      }.invert
      students = []
      CSV.foreach(filename,headers:true) do |row|
        student = Student.find_or_create_by(teacher: teacher,lauid: row["Unique User ID"])
        if student.username.nil?
          user_headers.map do |csv_field, field|
            student[field] = row[csv_field]
          end 
          student.save!
        end
        students << student
      end
      students
  end
end
