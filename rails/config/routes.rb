Rails.application.routes.draw do
  mount Api::Root => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
  resources :permissions

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
