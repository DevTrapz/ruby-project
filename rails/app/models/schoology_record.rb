class SchoologyRecord < ApplicationRecord
  belongs_to :student
  belongs_to :course
  def self.import_csv course_filename, teacher_email
    require 'csv'
    headers = CSV.read(course_filename,headers:true).headers
    data_headers = headers.reduce([]){|res, a| res << a if a.include?("ROA");res}

    #Import Teacher if not exist
    teacher = User.find_or_create_by(email: teacher_email)
    #Import Students of not exist
    students = Student.find_or_create_from_csv(course_filename, teacher).pluck(:lauid, :id).to_h
    #Import Course if not exist
    course = Course.find_or_create_by(name: course_filename, user: teacher)
    #Import Schoology record if not exist
    CSV.foreach(course_filename,headers:true) do |row|
      student_id = students[row['Unique User ID']]
      record = SchoologyRecord.find_or_initialize_by(student_id: students[row['Unique User ID']], course_id: course.id)
      record.grades = row.select{|header, value| data_headers.include?(header)}.to_h.as_json
      record.save!
    end
    
  end
end
