module PayloadHelper
  def check_payload response, payload_type
    case payload_type
    when "student"
      keys = ["lauid", "last_name", "first_name", "username"].sort
      expect(JSON.parse(response.body).keys.filter{|a| keys.include?(a)}.sort == keys).to eq(true)

    when "teacher_students"
      keys = ["lauid", "last_name", "first_name", "username"].sort
      expect(JSON.parse(response.body).all? { |a| a.keys.filter{|a| keys.include?(a)}.sort == keys }).to eq(true)

    when "student_grades"
      keys = ["attendance", "course", "grade"].sort
      expect(JSON.parse(response.body).all? { |a| a.keys.sort == keys }).to eq(true)

    when "teacher_grades"
      keys = ["attendance", "course", "grade"].sort
      JSON.parse(response.body).map {|a| a.first.second.all? { |a| expect(a.keys.sort == keys).to eq(true) } }  

    when "teacher"
      expect(JSON.parse(response.body)).to eq(Teacher.first.as_json)

    when "teacher_all"
      expect(JSON.parse(response.body)).to eq([Teacher.first].as_json)
      
    when "course_teacher"
      expect(JSON.parse(response.body).first.keys.include?("name")).to eq(true)
      
    when "course_all"
      JSON.parse(response.body).map{|a| expect(a.keys.include?("name")).to eq(true)}

    when "update"
      expect(JSON.parse(response.body)).to eq(Teacher.first.as_json)

    when "error"
      expect(JSON.parse(response.body).keys.first).to eq("error")

    when "success"
      expect(JSON.parse(response.body).keys.first).to eq("success")
    end
  end
end