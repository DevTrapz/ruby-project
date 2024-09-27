require "rails_helper"

describe Admin::Schoology, type: :request do
  
  context 'POST /schoology/upload_gradebook' do
    it 'uploads csv' do
      upload_csv
      expect(response.status).to eq(201)
      check_payload response, "success"
    end
    it 'uploads invalid csv format' do
      upload_csv "bad gradebook.csv"
      expect(response.status).to eq(400)
      check_payload response, "error"
    end
    it 'uploads invalid csv format' do
      upload_csv "gradebook.csv", false
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
  end
end