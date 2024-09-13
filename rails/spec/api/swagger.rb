require "rails_helper"

describe Api::Root, type: :request do
  context 'GET /swagger_doc' do
    it 'returns swagger docs for routes' do
      get '/swagger_doc'
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')
    end
  end
end