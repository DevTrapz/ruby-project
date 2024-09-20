module API
  class Root < Grape::API
    prefix 'api'
    format :json

    mount Admin::Courses
    mount Admin::Teachers
    mount Admin::Students
    mount Admin::Schoology
    add_swagger_documentation info: { title: "Admin API" }
  end
end