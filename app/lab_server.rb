require 'sinatra'
require 'csv'
require 'rack/handler/puma'
require 'pg'
require_relative '../lib/lab_exam'

set :port, 3000

get '/' do
  'Hello World'
end

get '/tests' do
  content_type :json

  LabTest.all_as_json
end

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'production'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
