require "rails_helper"

describe API::Root, type: :request do
  context 'GET /swagger_doc' do
    it 'returns swagger docs for routes' do
      get '/api/swagger_doc'
      expect(response.status).to eq(200)
    end
  end
end