require "rails_helper"

describe Admin::Teachers, type: :request do

  context 'GET /teachers/get_all' do
    it 'returns all teachers' do
      get "/api/teachers/get_all"
      expect(response.status).to eq(200)
    end
  end
  
  context 'POST /teachers/create' do
    before 'create a teacher' do
      response = create_teacher
      expect(response.status).to eq(201)
    end
    it 'attempt to create a teacher with existing email' do
      response = create_teacher
      expect(response.status).to eq(400)
    end
  end 

  context 'PUT /teachers/update' do
    before 'create a teacher' do
      params = {display_name: "Albert", email: "albert@math.edu"}
      post "/api/teachers/create", params: params
      expect(response.status).to eq(201)
      @id = JSON.parse(response.body)["id"]
    end
    it 'Update teacher name by id' do
      params = {id: "#{@id}" , display_name: "Nikola", email: "nickola@engineer.edu"}
      put "/api/teachers/update", params: params
      expect(response.status).to eq(200)
    end
  end
  
  # context 'DELETE /api/teachers/id' do
  #   before 'create a teacher' do
  #     params = {display_name: "Andrew", email: "test@email.com"}
  #     post "/api/teachers", params: params
  #     @id = JSON.parse(response.body)["id"]
  #     expect(response.status).to eq(201)
  #   end
  # end
  
  def create_teacher
    params = {display_name: "Issac", email: "issac.newton@math.edu"}
    post "/api/teachers/create", params: params
    return response
  end
end