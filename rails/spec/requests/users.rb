require "rails_helper"

describe Api::Root do
  context 'GET /swagger_doc' do
    it 'returns swagger docs for routes' do
      get '/swagger_doc'
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')
    end
  end
  context 'GET /api/users/all' do
    it 'returns all users' do
      get "/api/users/all"
      expect(response.body).to eq "[]"
    end
  end
end