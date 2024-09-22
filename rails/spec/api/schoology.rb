require "rails_helper"

describe Admin::Schoology, type: :request do
  
  context 'POST /schoology/upload_gradebook' do
    before :each  do
      @file = fixture_file_upload('gradebook-export-SAMPLE.csv', 'multipart/form-data')

      @params = {csv: @file, course_name: "pre-algebra", email: "issac.newton@math.edu"}
    end
    it 'uploads gradebook csv' do
      post '/api/schoology/upload_gradebook', params: @params
      expect(response.status).to eq(201)
      expect(response.content_type).to include('application/json')
    end
  end
end