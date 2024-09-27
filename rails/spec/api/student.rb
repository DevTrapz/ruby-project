require "rails_helper"

describe Admin::Students, type: :request do
  
  context 'POST /upload_gradebook/teacher/:teacher_id' do
    it 'Upload csv into students' do
      create_students 
      expect(response.status).to eq(201)
      check_payload response, "success"
    end
    it 'Attempt to upload a invalid csv format' do
      create_students "bad gradebook.csv"
      expect(response.status).to eq(400)
      check_payload response, "error"
    end
    it 'Attempt to upload csv using a non-existing teacher' do
      create_students "gradebook.csv", false
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
end


