module Users
  class API < Grape::API
    version "v1", using: :header, vendor: "users"
    format :json
    prefix :api

    resource :users do
      desc "Retrieve  all users"
      get :all do
        User.all
      end

      desc "Create a user"
      params do
        requires :display_name, type: String, desc: "User display name."
      end
      post do
        display_name = params[:display_name]
        User.create(display_name: display_name)
      end

      desc "Delete a user by id"
      params do
        requires :id, type: Integer, desc: "User id."
      end
      delete :id do
        begin
          id = params[:id]
          user = User.where(id: id).pluck(:display_name)
          User.find(id).destroy!
          status 200
          body({ success: true, id: id, message: "#{user[0]} deleted successfully" })
        rescue ActiveRecord::RecordNotFound
          status 404
          body({ success: false, id: id, message: "User does not exist" })
        end
      end
    end
  end
end
