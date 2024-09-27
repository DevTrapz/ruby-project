module Admin
  class Courses < Grape::API
    resource :courses do
      desc "Retrieve all courses"
      get :get_all do
        course = Course.all
        if course == []
          body({error: "no courses found" })
          return status 404
        end
        course
      end

      desc "Retrieve courses by teacher"
      params do
        requires :teacher_id, type: Integer
      end
      get "teacher/:teacher_id" do
        teacher = Teacher.where(id: params[:teacher_id]).first
        unless teacher
          body({error: "no teachers found" })
          return status 404
        end
        if teacher.courses == []
          body({error: "no courses found" })
          return status 404  
        end
        teacher.courses
      end
    end
  end 
end