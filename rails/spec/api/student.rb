require "rails_helper"

describe Admin::Students, type: :request do
  
  context 'POST /students/upload_gradebook' do
    it 'Upload gradebook csv into students' do
      response = create_students
      expect(response.status).to eq(201)
    end
  end
  
  context 'GET /students/teacher_students' do
    before do
      response = create_students
      expect(response.status).to eq(201)
    end
    it 'Retrieve all teachers students' do
      params = {teacher_id: Teacher.first.id}
      get '/api/students/teacher_students', params: params
      expect(response.status).to eq(200)
    end
  end
  
  context 'GET /students/student' do
    before do
      response = create_students
      expect(response.status).to eq(201)
    end
    it 'Retrieve student by lauid' do
      params = {lauid: Student.first.lauid}
      get '/api/students/student', params: params
      expect(response.status).to eq(200)
    end
    it 'Retrieve student by username' do
      params = {username: Student.first.username}
      get '/api/students/student', params: params
      expect(response.status).to eq(200)
    end
  end
  
  context 'GET /students/roa_teacher_students_grades' do
    before do
      response = create_students
      expect(response.status).to eq(201)
    end
    it 'Retrieve all student grades by teacher and ROA number' do
      params = {teacher_id: Teacher.first.id, roa_number: "1"}
      get '/api/students/roa_teacher_students_grades', params: params
      expect(response.status).to eq(200)
    end 
  end

  context 'GET /students/roa_student_grades' do
    before do
      response = create_students
      expect(response.status).to eq(201)
    end
    it 'Retrieve a student grades by lauid and ROA number' do
      params = {lauid: Student.first.lauid, roa_number: "1"}
      get '/api/students/roa_student_grades', params: params
      expect(response.status).to eq(200)
    end 
    it 'Retrieve a student grades by username and ROA number' do
      params = {username: Student.first.username, roa_number: "1"}
      get '/api/students/roa_student_grades', params: params
      expect(response.status).to eq(200)
    end 
  end

  def create_students
    @file = fixture_file_upload('gradebook-export-SAMPLE.csv', 'multipart/form-data')
    Teacher.create(display_name: "Issac", email: "issac.newton@math.edu")
    
    params = {csv: @file, teacher_id: Teacher.first.id}
    post '/api/students/upload_gradebook', params: params
    return response
  end
end