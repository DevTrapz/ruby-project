require 'csv'
module Admin
  class Students < Grape::API
    resource :students do
      desc "Upload gradebook csv into students", consumes: ['multipart/form-data']
      params do
        requires :csv, type: File, desc: "schoology grade book csv data"
        optional :teacher_id, type: String, desc: "teacher id"
      end
      post :upload_gradebook do
        filepath = params[:csv][:tempfile].path
        teacher = Teacher.where(id: params[:teacher_id][0])
        Student.find_or_create_from_csv(filepath, teacher)        
        body({ success: "csv uploaded successfully"})
      end

      desc "Retrieve all teacher's students" 
      params do
        requires :teacher_id, type: Integer, desc: "teacher id"
      end
      get :teacher_students do
        Teacher.find(params[:teacher_id]).students.all
      end

      desc "Retrieve student by lauid or username" 
      params do
        optional :lauid, type: String, desc: "student lauid"
        optional :username, type: String, desc: "student username id"
        exactly_one_of :lauid, :username
      end
      get :student do
        search = params.reject{ |k, v| v.nil? }.first
        students = Student.where("#{search[0]}": "#{search[1]}")
        students = students.map do |student|
          student.schoology_records
        end
      end

      desc "Retrieve all student grades by teacher and ROA number" 
      params do
        requires :teacher_id, type: Integer, desc: "teacher id"
        requires :roa_number, type: Integer, desc: "retrieve grades for a ROA number"
      end
      get :roa_teacher_students_grades do
        students = Student.where(teacher_id: params[:teacher_id])
        
        grades = students.map do |student|
          SchoologyRecord.get_grades(student.schoology_records, params[:roa_number])
        end
      end
      
      desc "Retrieve a student grades by lauid or username and ROA number" 
      params do
        requires :roa_number, type: Integer, desc: "retrieve grading period ROA number "
        optional :lauid, type: String, desc: "student lauid"
        optional :username, type: String, desc: "student username id"
        exactly_one_of :lauid, :username
      end
      get :roa_student_grades do
        search = params.reject{ |k, v| v.nil? || k == "roa_number"}.first
        student = Student.where("#{search[0]}": "#{search[1]}").first        

        SchoologyRecord.get_grades(student.schoology_records, params[:roa_number])
      end
    end
  end 
end