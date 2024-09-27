require "rails_helper"

describe Admin::Schoology, type: :request do
  
  context 'POST /schoology/upload_gradebook' do
    it 'uploads csv' do
      response = upload_csv
      expect(response.status).to eq(201)
      check_payload response, "success"
    end
    it 'uploads invalid csv format' do
      response = upload_csv "bad gradebook.csv"
      expect(response.status).to eq(400)
      check_payload response, "error"
    end
    it 'uploads invalid csv format' do
      response = upload_csv "gradebook.csv", false
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
  end
  
  def upload_csv csv="gradebook.csv", use_teacher=true
    file = fixture_file_upload(csv, 'multipart/form-data')
    teacher = Teacher.create(display_name: "Issac", email: "issac.newton@math.edu")
    teacher_id = use_teacher ? teacher.id : (teacher.id + 1)
    params = {csv: file, course_name: "pre-algebra"}
    post "/api/schoology/upload_gradebook/teacher/#{teacher_id}", params: params
    response
  end

  def check_payload response, payload_type
    case payload_type
    when "error"
      expect(JSON.parse(response.body).keys.first).to eq("error")
    when "success"
      expect(JSON.parse(response.body).keys.first).to eq("success")
    end
  end
end