require 'sinatra'
require 'rack/handler/puma'
require 'faraday'

set :port, 4000

BACKEND_API_URL = 'http://labs-backend:3000/tests'.freeze
ALLOWED_FILE_TYPES = ['text/csv', 'application/vnd.ms-excel'].freeze

get '/' do
  content_type 'text/html'

  File.open('index.html')
end

get '/load-exams' do
  content_type :json
  api_response = Faraday.get(BACKEND_API_URL)

  response.status = 500 unless api_response.success?

  api_response.body
end

get '/load-exams/:token' do
  content_type :json
  api_response = Faraday.get("#{BACKEND_API_URL}/#{params[:token]}")

  response.status = 500 unless api_response.success?

  api_response.body
end

post '/import' do
  content_type :json

  unless params[:file]
    response.status = 400
    return { error: 'The request does not contain any file.'}.to_json
  end

  file = params[:file][:tempfile]
  filetype = params[:file][:type]

  unless ALLOWED_FILE_TYPES.include? filetype
    response.status = 422
    return { error: 'File type not supported.'}.to_json
  end

  api_response = Faraday.get("#{BACKEND_API_URL}/import")

  response.status = 500 unless api_response.success?

  api_response.body
end

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'production'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 4000,
    Host: '0.0.0.0'
  )
end
