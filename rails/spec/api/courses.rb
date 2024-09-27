require "rails_helper"


describe Admin::Courses, type: :request do
  context 'GET /courses/get_all' do
    it 'Retrieve all courses' do
      import_csv
      get '/api/courses/get_all'
      expect(response.status).to eq(200)
      check_payload response, "course_all"
    end
    it 'Retrieve all courses' do
      get '/api/courses/get_all'
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
  end
  
  context 'GET /courses/teacher' do
    it 'retrieve all courses by teacher' do
      import_csv
      get "/api/courses/teacher/#{Teacher.first.id}"
      expect(response.status).to eq(200)
      check_payload response, "course_teacher"
    end
    it 'attempt to retrieve all courses by non-existing teacher' do
      get "/api/courses/teacher/1"
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
    it 'attempt to retrieve non-existing courses' do
      create_teacher
      get "/api/courses/teacher/#{Teacher.first.id}"
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
  end
end 