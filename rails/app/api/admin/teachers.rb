module Admin
  class Teachers < Grape::API     
      resource :teachers do
        desc "Retrieve all teachers"
        get :get_all do
          Teacher.all
        end
    
        desc "Create a teacher"
        params do
          requires :display_name, type: String
          requires :email, type: String, regexp: /.+@.+/
        end
        post :create do
          begin
            User.create(display_name: params[:display_name], email: params[:email])
          rescue ActiveRecord::RecordNotUnique
            status 400
            body({error: "email already exist" })
          end  
        end
    
        desc "Update a teacher's email or name"
        params do
          requires :id, type: Integer
          optional :email, type: String
          optional :display_name, type: String
          at_least_one_of :email, :display_name
        end
        put :update do
          begin
            updates = params.reject{ |key, value| value.nil? || key == "id"}
            teacher = Teacher.find(params[:id])
            teacher.update(updates)
            status 200
            body({ success: "user updated successfully", id: params[:id]})
          rescue ActiveRecord::RecordNotFound
            status 404
            body({ error: "user does not exist" })
          end
        end
    
        # desc "Delete a user by id"
        # params do
        #   requires :id, type: Integer, desc: "user id"
        # end
        # delete :id do
        #   id = params[:id]
        #   begin
        #     user = User.find(id)
        #     user.destroy!
        #     status 200
        #     body({ success: "#{user.display_name} deleted successfully" })
        #   rescue ActiveRecord::RecordNotFound
        #     status 404
        #     body({ error: "user does not exist" })
        #   end
        # end
      end
    end
  end