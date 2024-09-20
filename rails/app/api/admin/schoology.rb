require 'csv'
module Admin
  class Schoology < Grape::API
    resource :schoology do
      desc "Upload gradebook csv into students, create a teacher if they don't already exist and course", consumes: ['multipart/form-data']
      params do
        requires :csv, type: File, desc: "schoology grade book csv data"
        requires :course_name, type: String, desc: "course name"
        optional :email, type: String, desc: "teacher email"
      end
      post :upload_gradebook do
        begin
          SchoologyRecord.import_csv(params[:csv][:tempfile].path, params[:email], params[:course_name])
          body({ success: "csv uploaded successfully"})
        rescue
          status 400
          body({ failed: "csv uploaded failed"})
        end
      end
    end
  end 
end