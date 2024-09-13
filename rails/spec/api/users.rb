require "rails_helper"

describe Admin::Users, type: :request do

  context 'GET /api/users/all' do
    it 'returns all users' do
      get "/api/users/all"
      expect(response.status).to eq(200)
      expect(response.body).to eq "[]"
    end
  end
  
  context 'POST /api/users' do
    before 'create a user' do
      response = create_user()
      expect(response.status).to eq(201)
    end
    it 'attempt to create a user with existing email' do
      response = create_user()
      expect(response.status).to eq(400)
    end
  end 

  context 'PUT /api/users/id' do
    headers = { "CONTENT_TYPE" => "application/json" }
    before 'create a user' do
      params = Grape::Json.dump(display_name: "Andrew", email: "test@email.com")
      post "/api/users", params: params, headers: headers
      @id = JSON.parse(response.body)["id"]
      expect(response.status).to eq(201)
    end
    it 'Update user name by id' do
      params = Grape::Json.dump(id: "#{@id}" , display_name: "Wix")
      put "/api/users/id", params: params , headers: headers
      expect(response.status).to eq(200)
    end
  end
  
  context 'DELETE /api/users/id' do
    headers = { "CONTENT_TYPE" => "application/json" }
    before 'create a user' do
      params = Grape::Json.dump(display_name: "Andrew", email: "test@email.com")
      post "/api/users", params: params, headers: headers
      @id = JSON.parse(response.body)["id"]
      expect(response.status).to eq(201)
    end
  end
  
  def create_user()
    headers = { "CONTENT_TYPE" => "application/json" }
    params = Grape::Json.dump(display_name: "Andrew", email: "test@email.com")
      post "/api/users", params: params, headers: headers
    return response
  end
end