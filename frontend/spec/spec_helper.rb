require_relative '../server'

def app
  Sinatra::Application
end

require 'capybara/cuprite'
require 'capybara/rspec'
require 'rspec'
require 'rack/test'
require 'sinatra'
require 'faraday'

ENV['RACK_ENV'] = 'test'

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Drive.new(app,
    window_size: [1200, 800],
    browser_options: { 'no_sandbox': nil },
    js_errors: false,
    headless: %w[0],
    process_timeout: 15,
    timeout: 10
  )
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Capybara::DSL

  config.before(:each, type: :system) do
    Capybara.javascript_driver = :cuprite
    Capybara.current_driver = Capybara.javascript_driver
    Capybara.app_host = 'http://localhost:4000'
    Capybara.default_max_wait_time = 5
    Capybara.disable_animation = true
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
