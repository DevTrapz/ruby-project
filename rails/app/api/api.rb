module API
  class Root < Grape::API
    prefix 'api'
    format :json

    mount Admin::Users
    add_swagger_documentation info: { title: "Admin API" }
  end
end