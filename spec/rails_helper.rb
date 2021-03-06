ENV['RAILS_ENV'] = 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/email/rspec'
require 'capybara/poltergeist'
require 'cancan/matchers'
require 'shoulda-matchers'
require 'sidekiq/testing'
require 'thinking_sphinx/test'

ThinkingSphinx::Test.init
Sidekiq::Testing.fake!

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

abort("The Rails environment is running in production mode!") if Rails.env.production?

ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include OmniauthMacros
  config.extend ControllerMacros, type: :controller
  config.include AcceptanceHelper, type: :feature

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  # Transactional fixtures work with real-time indices
  config.use_transactional_fixtures = true

  config.before :each do |example|
    # Configure and start Sphinx for request specs
    if example.metadata[:type] == :request
      ThinkingSphinx::Test.init
      ThinkingSphinx::Test.start index: false
    end

    # Disable real-time callbacks if Sphinx isn't running
    ThinkingSphinx::Configuration.instance.settings['real_time_callbacks'] =
      (example.metadata[:type] == :request)
  end

  config.after(:each) do |example|
    # Stop Sphinx and clear out data after request specs
    if example.metadata[:type] == :request
      ThinkingSphinx::Test.stop
      ThinkingSphinx::Test.clear
    end
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  OmniAuth.config.test_mode = true

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
      with.library :active_record
    end
  end
end
