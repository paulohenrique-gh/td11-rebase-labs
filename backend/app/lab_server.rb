require 'sinatra'
require 'rack/handler/puma'
require_relative '../lib/lab_exam'

set :port, 3000

get '/' do
  'Hello World'
end

get '/tests' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'

  LabExam.exams_as_json
end

get '/tests/:token' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'

  LabExam.exams_as_json(params[:token].upcase)
end

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'production'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
