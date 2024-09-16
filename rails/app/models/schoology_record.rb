class SchoologyRecord < ApplicationRecord
  belongs_to :student, -> {select("*,first_name || ' ' || last_name || ' (' || username || ')' as name")}, class_name: "Student", foreign_key: "student_id"
  belongs_to :course

  def get_roa roa_number=1
    roa_headers = grades.to_h.keys.select{|k| k.include?("ROA #{roa_number}")}
    grades.select{|header,value| roa_headers.include?(header)}.to_h
  end

  def course_attendance_grade roa_number=1, days_in_roa = 8
    assignments = get_roa(roa_number).select{|header,value| header.include?("Grading Category: ")}
    completed = assignments.values.map {|value| (value.to_i > 0) ? 1 : 0 }.sum
    percentage = (completed.to_f/assignments.count)
    {
      completed_assignments: completed,
      total_assignments: assignments.count,
      percentage: percentage.round(3),
      days: (days_in_roa*percentage).round
    }
  end

  def course_grade roa_number=1
    (get_roa(roa_number).find{|header,value| header.include?("- Category Score")}[1].to_f/100).round(3)
  end

  def self.get_grades schoology_records, roa_number
    schoology_records.includes(:student,:course).map do |a| 
      [a.student.name, 
        { 
          course: a.course.name,
          grade: a.course_grade(roa_number),
          attendance: a.course_attendance_grade(roa_number),
        }
      ]
    end.group_by do |a| 
      a[0]
    end.map do |k,v| 
      [k, v.map{|a| a[1]}]
    end.to_h
  end

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
