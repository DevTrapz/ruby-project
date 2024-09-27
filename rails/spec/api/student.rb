require "rails_helper"

describe Admin::Students, type: :request do
  
  context 'POST /upload_gradebook/teacher/:teacher_id' do
    it 'Upload csv into students' do
      response = create_students 
      expect(response.status).to eq(201)
      check_payload response, "success"
    end
    it 'Attempt to upload a invalid csv format' do
      response = create_students "bad gradebook.csv"
      expect(response.status).to eq(400)
      check_payload response, "error"
    end
    it 'Attempt to upload csv using a non-existing teacher' do
      response = create_students "gradebook.csv", false
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
  end
  
  context 'GET /teacher/:teacher_id' do
    before do
      create_students
    end
    it 'Retrieve all students that belongs to a teacher' do
      get "/api/students/teacher/#{Teacher.first.id}"
      expect(response.status).to eq(200)
      check_payload response, "teacher_students"
    end
    it 'Attempt to retrieve all students that belongs to non-existing teacher' do
      get "/api/students/teacher/#{Teacher.first.id + 1}"
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
  end
  
  context 'GET /student/:student_id' do
    before do
      create_students
    end
    it 'Retrieve a student' do
      get "/api/students/student/#{Student.first.id}"
      expect(response.status).to eq(200)
      check_payload response, "student"
    end
    it 'Attempt to retrieve a non-existing student' do
      get "/api/students/student/#{Student.first.id - 1}"
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
  end
  
  context 'GET /grades/teacher/:teacher_id/roa/:roa_number' do
    before do
      import_csv
    end
    it 'Retrieve all student grades by teacher and ROA number' do
      get "/api/students/grades/teacher/#{Teacher.first.id}/roa/1"
      expect(response.status).to eq(200)
      check_payload response, "teacher_grades"
    end 
    it 'Attempt to retrieve all student grades by non-existing teacher' do
      get "/api/students/grades/teacher/#{Teacher.first.id + 1}/roa/1"
      expect(response.status).to eq(404)
      check_payload response, "error"
    end 
    it 'Attempt to retrieve all student grades by non-existing roa' do
      get "/api/students/grades/teacher/#{Teacher.first.id }/roa/10"
      expect(response.status).to eq(404)
      check_payload response, "error"
    end 
  end
  
  context 'GET /grades/student/:student_id/roa/:roa_number' do
    before do
      import_csv
    end
    it 'Retrieve a student grades' do
      get "/api/students/grades/student/#{Student.first.id}/roa/1"
      expect(response.status).to eq(200)
      check_payload response, "student_grades"
    end 
    it 'Attempt to retrieve a non-exsiting student grades' do
      student = Student.first.destroy
      get "/api/students/grades/student/#{student.id}/roa/1"
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
    it 'Attempt to retrieve a student grades using a non-exsiting roa' do
      get "/api/students/grades/student/#{Student.first.id}/roa/10"
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
  end
  
  def create_students fixture_file="gradebook.csv", use_teacher=true
    @file = fixture_file_upload(fixture_file, 'multipart/form-data')
    teacher = Teacher.create(display_name: "Issac", email: "issac.newton@math.edu")
    teacher_id = use_teacher ? Teacher.first.id : (Teacher.first.id + 1)
    params = {csv: @file}
    post "/api/students/upload_gradebook/teacher/#{teacher_id}", params: params
    response
  end
  
  def import_csv 
    Teacher.create(display_name: "Issac", email: "issac.newton@math.edu")
    file = fixture_file_upload("gradebook.csv", 'multipart/form-data').path
    SchoologyRecord.import_csv(file, Teacher.first.email, "pre-algebra")
  end

  def check_payload response, payload_type
    case payload_type
    when "student"
      keys = ["lauid", "last_name", "first_name", "username"].sort
      expect(JSON.parse(response.body).keys.filter{|a| keys.include?(a)}.sort == keys).to eq(true)
    when "teacher_students"
      keys = ["lauid", "last_name", "first_name", "username"].sort
      expect(JSON.parse(response.body).all? { |a| a.keys.filter{|a| keys.include?(a)}.sort == keys }).to eq(true)
    when "student_grades"
      keys = ["attendance", "course", "grade"].sort
      expect(JSON.parse(response.body).all? { |a| a.keys.sort == keys }).to eq(true)
    when "teacher_grades"
      keys = ["attendance", "course", "grade"].sort
      JSON.parse(response.body).map {|a| a.first.second.all? { |a| expect(a.keys.sort == keys).to eq(true) } }  
    when "error"
      expect(JSON.parse(response.body).keys.first).to eq("error")
    when "success"
      expect(JSON.parse(response.body).keys.first).to eq("success")
    end
  end
end