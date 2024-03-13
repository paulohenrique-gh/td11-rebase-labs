require 'csv'
require 'sinatra'
require 'rack/handler/puma'
require_relative '../lib/lab_exam'
require_relative '../lib/helpers/csv_handler'
require_relative '../lib/jobs/import_csv_job'

set :port, 3000

ALLOWED_FILE_TYPES = ['text/csv', 'application/vnd.ms-excel'].freeze

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

post '/import' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'

  unless params[:file]
    response.status = 400
    return { error: 'The request does not contain any file.'}.to_json
  end

  file = params[:file][:tempfile]
  filetype = params[:file][:type]

  unless ALLOWED_FILE_TYPES.include? filetype
    response.status = 422
    return { error: 'File type is not CSV.' }.to_json
  end

  rows = CSV.read(file, col_sep: ';')

  ImportCsvJob.perform_async(rows)
  { message: 'Processing file.' }.to_json
end

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'production'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
