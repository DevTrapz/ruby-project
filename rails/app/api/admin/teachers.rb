module Admin
  class Teachers < Grape::API     
      resource :teachers do
        desc "Create a teacher"
        params do
          requires :display_name, type: String, regexp: /[A-Za-z0-9]/
          requires :email, type: String, regexp: /.+@.+/
        end
        post :create do
          begin
            User.create(display_name: params[:display_name], email: params[:email])
          rescue ActiveRecord::RecordNotUnique
            body({error: "email already exist" })
            status 400
          end  
        end

        desc "Retrieve all teachers"
        get :get_all do
          teacher = Teacher.all
          if teacher == []
            body({error: "no teachers found" })
            return status 404
          end
          teacher
        end
    
        desc "Update a teacher's email or name"
        params do
          requires :teacher_id, type: Integer
          optional :email, type: String, regexp: /.+@.+/
          optional :display_name, type: String, regexp: /[A-Za-z0-9]/
          at_least_one_of :email, :display_name
        end
        put "update/:teacher_id" do
          teacher = Teacher.where(id: params[:teacher_id])
          updates = params.reject{ |key, value| value.nil? || key == "teacher_id"}
          unless teacher.first
            body({ error: "teacher does not exist" })
            return status 404
          end
          status 200
          teacher.update(updates).first
        end
      end
    end
  end