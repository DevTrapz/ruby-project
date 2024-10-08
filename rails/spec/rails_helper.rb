ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  require_relative "support/db_helper"
  require_relative "support/payload_helper"
  config.include DbHelper
  config.include PayloadHelper
  
  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: "/app/api", namespace: "Api"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end
