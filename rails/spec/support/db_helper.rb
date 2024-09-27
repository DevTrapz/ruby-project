module DbHelper
  def import_csv 
    Teacher.create(display_name: "Issac", email: "issac.newton@math.edu")
    file = fixture_file_upload("gradebook.csv", 'multipart/form-data').path
    SchoologyRecord.import_csv(file, Teacher.first.email, "pre-algebra")
  end

  def create_students fixture_file="gradebook.csv", use_teacher=true
    @file = fixture_file_upload(fixture_file, 'multipart/form-data')
    teacher = Teacher.create(display_name: "Issac", email: "issac.newton@math.edu")
    teacher_id = use_teacher ? Teacher.first.id : (Teacher.first.id + 1)
    params = {csv: @file}
    post "/api/students/upload_gradebook/teacher/#{teacher_id}", params: params
    response
  end

  def create_teacher
    params = {display_name: "Issac", email: "issac.newton@math.edu"}
    post "/api/teachers/create", params: params
    response
  end

  def upload_csv csv="gradebook.csv", use_teacher=true
    file = fixture_file_upload(csv, 'multipart/form-data')
    teacher = Teacher.create(display_name: "Issac", email: "issac.newton@math.edu")
    teacher_id = use_teacher ? teacher.id : (teacher.id + 1)
    params = {csv: file, course_name: "pre-algebra"}
    post "/api/schoology/upload_gradebook/teacher/#{teacher_id}", params: params
    response
  end
end