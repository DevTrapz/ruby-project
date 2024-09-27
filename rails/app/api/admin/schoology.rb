require 'csv'
module Admin
  class Schoology < Grape::API
    resource :schoology do
      desc "Upload gradebook csv into students, create a teacher if they don't already exist and course", consumes: ['multipart/form-data']
      params do
        requires :csv, type: File, desc: "schoology grade book csv data"
        requires :teacher_id, type: Integer
        requires :course_name, type: String
      end
      post "upload_gradebook/teacher/:teacher_id" do
        begin
          filepath = params[:csv][:tempfile].path
          unless SchoologyRecord.validate_csv(filepath)
            body({ error: "csv invalid format"})
            return status 400
          end
          teacher = Teacher.where(id: params[:teacher_id]).first
          unless teacher
            body({ error: "teacher does not exist" })
            return status 404        
          end
          SchoologyRecord.import_csv(filepath, teacher.email, params[:course_name])
          body({ success: "csv uploaded successfully"})
        rescue
          status 400
          body({ failed: "csv uploaded failed"})
        end
      end
    end
  end 
end