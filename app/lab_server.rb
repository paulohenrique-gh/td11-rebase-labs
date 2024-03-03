require 'sinatra'
require 'csv'
require 'rack/handler/puma'
require 'pg'

set :port, 3000

get '/' do
  'Hello World'
end

get '/tests' do
  content_type :json

  conn = PG.connect(
    dbname: 'postgres',
    user: 'postgres',
    password: 'password',
    host: 'db',
    port: 5432
  )

  conn.exec('SELECT * FROM exames').entries.to_json
end

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'production'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
