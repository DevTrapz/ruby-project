class SchoologyRecord < ApplicationRecord
  belongs_to :student, -> {select("*,first_name || ' ' || last_name || ' (' || username || ')' as name")}, class_name: "Student", foreign_key: "student_id"
  belongs_to :course

  def get_roa_headers roa_number=1
    roa_headers = grades.to_h.keys.select{|k| k.include?("ROA #{roa_number}")}
  end

  def get_roa roa_number=1
    roa_headers = get_roa_headers(roa_number)
    grades.select{|header,value| roa_headers.include?(header)}.to_h
  end

  def get_roa_data_from_headers roa_number=1
    roa_headers = get_roa_headers(roa_number)
    roa_headers.reject!{|a| a.include?("- Category Score")}
    line = Struct.new(:points,:date,:cat)
    regex = /\(Max Points: (.*?), Due Date: (.*?), Grading Category: (.*?)\)/
    roa_headers.map do |header|
      header.match(regex){|m| line.new(*m.captures)}.to_h
    end. map do |hash|
      hash[:date] = DateTime.strptime(hash[:date], '%m/%d/%y')
      hash
    end

  end

  def course_attendance_grade roa_number=1, days_in_roa
    assignments = get_roa(roa_number).select{|header,value| header.include?("Grading Category: ")}
    completed = assignments.values.map {|value| (value.to_i > 0) ? 1 : 0 }.sum
    percentage = (completed.to_f/assignments.count)
    roa_data = get_roa_data_from_headers(roa_number)
    # All days between dates (Include weekends)
    # days_in_roa = (roa_data.max{|a| a[:date]}[:date] - roa_data.min{|a| a[:date]}[:date]).to_i
    # weekdays only
    days_in_roa = days_in_roa || (roa_data.min{|a| a[:date]}[:date]..roa_data.max{|a| a[:date]}[:date]).count {|date| date.wday >= 1 && date.wday <= 5}
    days = (days_in_roa*percentage).round(2)
    {
      completed_assignments: completed,
      total_assignments: assignments.count,
      percentage: percentage.round(3),
      days_in_roa: days_in_roa,
      days: days,
      days_under: days_in_roa - days
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

  def self.import_csv course_filename, teacher_email, course_name
    require 'csv'
    headers = CSV.read(course_filename,headers:true).headers
    data_headers = headers.reduce([]){|res, a| res << a if a.include?("ROA");res}

    #Import Teacher if not exist
    teacher = Teacher.find_or_create_by(email: teacher_email)
    #Import Students of not exist
    students = Student.find_or_create_from_csv(course_filename, teacher).pluck(:lauid, :id).to_h
    #Import Course if not exist
    course = Course.find_or_create_by(name: course_name, teacher: teacher)
    #Import Schoology record if not exist
    CSV.foreach(course_filename,headers:true) do |row|
      student_id = students[row['Unique User ID']]
      record = SchoologyRecord.find_or_initialize_by(student_id: students[row['Unique User ID']], course_id: course.id)
      record.grades = row.select{|header, value| data_headers.include?(header)}.to_h.as_json
      record.save!
    end
    
  end
end
