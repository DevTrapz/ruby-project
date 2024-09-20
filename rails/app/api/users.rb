module Users
  class API < Grape::API
    version 'v1', using: :header, vendor: "users"
    format :json
    prefix :api

    resource :users do
      desc "Retrieve  all users"
      get :all do
        User.all
      end

      desc "Create a user"
      params do
        requires :display_name, type: String, desc: 'User display name.'
      end
      post do
        display_name = params[:display_name]
        User.create(display_name: display_name)
      end

      desc "Update a user by id"
      params do
        requires :id, type: Integer, desc: 'User id.'
      end
      put :id do
        begin
          User.find(params[:id])
          status 200
          body({ success: true, message: "User deleted successfully" })
        rescue ActiveRecord::RecordNotFound
          status 404
          body({ success: false, user_id: params[:id], message: "User does not exist" })
        end
      end

      desc "Delete a user by id"
      params do
        requires :id, type: Integer, desc: 'User id.'
      end
      delete :id do
        begin
          name = User.find(params[:id])
          User.find(params[:id]).destroy!
          status 200
          body({ success: true, message: "User deleted successfully" })
        rescue ActiveRecord::RecordNotFound
          status 404
          body({ success: false, user_id: params[:id], message: "User does not exist" })
        end
      end
    end
  end
end