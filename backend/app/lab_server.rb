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

  LabExam.all_as_json
end

get '/tests/:token' do
  content_type :json

  {
    "exam_result_token": "IQCZ17",
    "exam_result_date": "2022-11-94",
    "patient": {
      "patient_cpf": "048.445.170-88",
      "patient_name": "Renato Barbosa",
      "patient_email": "renato.barbosa@ebert-quigley.com",
      "patient_birthdate": "1999-03-19",
      "patient_address": "192 Rua Pedras",
      "patient_city": "Ituverava",
      "patient_state": "Alagoas"
    },
    "doctor": {
      "doctor_crm": "P91IKM9114",
      "doctor_crm_state": "PI",
      "doctor_name": "Joao Carlos Azevedo",
      "doctor_email": "joao.azevedo@wisozk.biz"
    },
    "tests": [
      {
        "test_type": "leucócitos",
        "test_type_limits": "9-61",
        "test_type_results": "75"
      },
      {
        "test_type": "hemácias",
        "test_type_limits": "45-52",
        "test_type_results": "48"
      }
    ]
  }.to_json
end

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'production'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
