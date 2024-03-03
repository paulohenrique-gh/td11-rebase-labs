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

  db_name = if ENV['RACK_ENV'] == 'test'
              'test'
            else
              'development'
            end

  conn = PG.connect(dbname: db_name, user: 'postgres',
                    password: 'password', host: 'db', port: 5432)

  exams = conn.exec('SELECT * FROM exames').entries.to_json
  conn.close if conn

  exams
end

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'production'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
