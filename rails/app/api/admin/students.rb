require 'csv'
module Admin
  class Students < Grape::API
    resource :students do
      desc "Upload gradebook csv into students", consumes: ['multipart/form-data']
      params do
        requires :csv, type: File, desc: "schoology grade book csv data"
        requires :teacher_id, type: Integer, desc: "teacher id"
      end
      post "upload_gradebook/teacher/:teacher_id" do
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
        Student.find_or_create_from_csv(filepath, teacher)        
        body({ success: "csv uploaded successfully"})
      end

      desc "Retrieve all teacher students" 
      params do
        requires :teacher_id, type: Integer
      end
      get "teacher/:teacher_id" do
        teacher = Teacher.where(id: params[:teacher_id]).first
        unless teacher
          body({ error: "teacher does not exist" })
          return status 404        
        end
        teacher.students.all
      end

      desc "Retrieve a student" 
      params do
        requires :student_id, type: Integer
      end
      get "student/:student_id" do
        student = Student.where(id: params[:student_id]).first
        unless student
          body({ error: "teacher does not exist" })
          return status 404        
        end
        student
      end
      
      desc "Retrieve all student grades by teacher id and ROA number" 
      params do
        requires :teacher_id, type: Integer
        requires :roa_number, type: Integer
      end
      get "grades/teacher/:teacher_id/roa/:roa_number" do
        unless Teacher.where(id: params[:teacher_id]).first
          body({ error: "teacher does not exist" })
          return status 404        
        end
        roa = Student.last.schoology_records.map{|a| a.get_roa(params[:roa_number])}.first
        if roa == {}
          body({ error: "roa does not exist" })
          return status 404        
        end
        students = Student.where(teacher_id: params[:teacher_id])
        
        grades = students.map do |student|
          SchoologyRecord.get_grades(student.schoology_records, params[:roa_number])
        end
      end
      
      desc "Retrieve a student grades by lauid or username and ROA number" 
      params do
        requires :roa_number, type: Integer, desc: "retrieve grades by ROA number"
        requires :student_id, type: Integer
      end
      get "grades/student/:student_id/roa/:roa_number" do
        student = Student.where(id: params[:student_id]).first
        unless student
          body({ error: "student does not exist" })
          return status 404        
        end
        roa = Student.last.schoology_records.map{|a| a.get_roa(params[:roa_number])}.first
        if roa == {}
          body({ error: "roa does not exist" })
          return status 404        
        end
        SchoologyRecord.get_grades(student.schoology_records, params[:roa_number]).first.last
      end
    end
  end 
end