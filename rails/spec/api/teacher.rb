require "rails_helper"

describe Admin::Teachers, type: :request do
  
  context 'POST /create' do
    before 'create a teacher' do
      create_teacher
      expect(response.status).to eq(201)
      check_payload response, "teacher"
    end
    it 'attempt to create a teacher with existing email' do
      create_teacher
      expect(response.status).to eq(400)
      check_payload response, "error"
    end
  end 
  
  context 'GET /get_all' do
    before 'create teacher' do
      create_teacher
    end
    it 'return the first teachers' do
      get "/api/teachers/get_all"
      expect(response.status).to eq(200)
      check_payload response, "teacher_all"
    end
    it 'delete teacher, then attempt to return teacher' do
      Teacher.first.destroy
      get "/api/teachers/get_all"
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
  end
  
  
  context 'PUT /update/:teacher_id' do
    before 'create a teacher' do
      create_teacher
      @id = JSON.parse(response.body)["id"]
      @params = {display_name: "Nikola", email: "nickola@engineer.edu"}
    end
    it 'update teacher name by id' do
      put "/api/teachers/update/#{@id}", params: @params
      expect(response.status).to eq(200)
      check_payload response, "update"
    end
    it 'delete a teacher, then attempt to update that teacher' do
      Teacher.first.destroy
      put "/api/teachers/update/#{@id}", params: @params
      expect(response.status).to eq(404)
      check_payload response, "error"
    end
  end
end