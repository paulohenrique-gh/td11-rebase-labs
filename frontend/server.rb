require 'sinatra'
require 'rack/handler/puma'
require 'faraday'

set :port, 4000

BACKEND_API_URL = 'http://labs-backend:3000/tests'.freeze

get '/' do
  content_type 'text/html'

  File.open('index.html')
end

get '/load-tests' do
  content_type :json
  response = Faraday.get(BACKEND_API_URL)

  response.body
end

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'production'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 4000,
    Host: '0.0.0.0'
  )
end
