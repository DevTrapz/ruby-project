class UserAPI < Grape::API
  version "v1", using: :header, vendor: "users"
  format :json
  prefix :api
  
  resource :users do
    desc "Retrieve all users"
    get :all do
      User.all
    end

    desc "Create a user"
    params do
      requires :display_name, type: String, desc: "user display name"
      requires :email, type: String, desc: "user email"
    end
    post do
      begin
        User.create(display_name: params[:display_name], email: params[:email])
      rescue ActiveRecord::RecordNotUnique
        status 400
        body({error: "email already exist" })
      end  
    end

    desc "Update a user by id"
    params do
      requires :id, type: Integer, desc: "user id"
      optional :email, type: String, desc: "user email"
      optional :display_name, type: String, desc: "user display name"
    end
    put :id do
      begin
        display_name = params[:display_name]
        id = params[:id]
        user = User.find(id)
        user.update(display_name: display_name)
        status 200
        body({ success: "user updated successfully", id: "#{id}" })
      rescue ActiveRecord::RecordNotFound
        status 404
        body({ error: "user does not exist" })
      end
    end

    desc "Delete a user by id"
    params do
      requires :id, type: Integer, desc: "user id"
    end
    delete :id do
      id = params[:id]
      begin
        user = User.find(id)
        user.destroy!
        status 200
        body({ success: "#{user.display_name} deleted successfully" })
      rescue ActiveRecord::RecordNotFound
        status 404
        body({ error: "user does not exist" })
      end
    end
  end
end

module Api
  class Root < Grape::API
    format :json
    version "v1", using: :header, vendor: "API"

    mount UserAPI
    add_swagger_documentation info: { title: "My API" }
  end
end

