require 'csv'
module Admin
  class Courses < Grape::API
    resource :courses do
      desc "Retrieve all courses"
      get :get_all do
        Course.all
      end

      desc "Retrieve courses by teacher"
      params do
        optional :id, type: String
        optional :email, type: String
        exactly_one_of :email, :id
      end
      get :teacher do
        search = params.reject{ |k, v| v.nil? }.first
        Teacher.where("#{search[0]}": "#{search[1]}").first.courses
      end
    end
  end 
end