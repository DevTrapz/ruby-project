require "rails_helper"

describe Admin::Courses, type: :request do
  context '/courses/get_all' do
    it 'Retrieve all courses' do
      get '/api/courses/get_all'
      expect(response.status).to eq(200)
    end
  end

  context '/courses/teacher' do
    before 'create courses' do
      file = fixture_file_upload('gradebook-export-SAMPLE.csv', 'multipart/form-data')
      params = {csv: file, course_name: "pre-algebra", email: "issac.newton@math.edu"}
      post '/api/schoology/upload_gradebook', params: params
    end
    it 'retrieve all courses by teacher id' do
      params = {id: Teacher.first.id}
      get '/api/courses/teacher', params: params
      expect(response.status).to eq(200)
    end
    it 'retrieve all courses by teacher email' do
      params = {email: Teacher.first.email}
      get '/api/courses/teacher', params: params
      expect(response.status).to eq(200)
    end
  end
end 