require 'spec_helper'

describe 'GET /load-tests' do
  it 'returns full list of exams from the backend' do
    fake_response_body = [
      {
        "exam_result_token": "IQCZ17",
        "exam_result_date": "2021-08-05",
        "patient": {
          "patient_cpf": "048.973.170-88",
          "patient_name": "Emilly Batista Neto",
          "patient_email": "gerald.crona@ebert-quigley.com",
          "patient_birthdate": "2001-03-11",
          "patient_address": "165 Rua Rafaela",
          "patient_city": "Ituverava",
          "patient_state": "Alagoas"
        },
        "doctor": {
          "doctor_crm": "B000BJ20J4",
          "doctor_crm_state": "PI",
          "doctor_name": "Maria Luiza Pires",
          "doctor_email": "denna@wisozk.biz"
        },
        "tests": [
          {
            "test_type": "hemácias",
            "test_type_limits": "45-52",
            "test_type_results": "97"
          },
          {
            "test_type": "leucócitos",
            "test_type_limits": "9-61",
            "test_type_results": "89"
          }
        ]
      },
      {
        "exam_result_token": "0W9I67",
        "exam_result_date": "2021-07-09",
        "patient": {
          "patient_cpf": "048.108.026-04",
          "patient_name": "Juliana dos Reis Filho",
          "patient_email": "mariana_crist@kutch-torp.com",
          "patient_birthdate": "1995-07-03",
          "patient_address": "527 Rodovia Júlio",
          "patient_city": "Lagoa da Canoa",
          "patient_state": "Paraíba"
        },
        "doctor": {
          "doctor_crm": "B0002IQM66",
          "doctor_crm_state": "SC",
          "doctor_name": "Maria Helena Ramalho",
          "doctor_email": "rayford@kemmer-kunze.info"
        },
        "tests": [
          {
            "test_type": "hemácias",
            "test_type_limits": "45-52",
            "test_type_results": "28"
          },
          {
            "test_type": "leucócitos",
            "test_type_limits": "9-61",
            "test_type_results": "91"
          }
        ]
      }
    ].to_json
    fake_response = double('Faraday::Response', body: fake_response_body, success?: true)
    allow(Faraday).to receive(:get).and_return(fake_response)

    get '/load-exams'

    expect(last_response.status).to eq 200
    expect(last_response.content_type).to include 'application/json'
    json_response = JSON.parse(last_response.body, symbolize_names: true)
    expect(json_response.class).to eq Array
    expect(json_response.first[:exam_result_token]).to eq 'IQCZ17'
    expect(json_response.last[:exam_result_token]).to eq '0W9I67'
  end

  it 'returns an empty array when there are no exams' do
    fake_response_body = []
    fake_response = double('Faraday::Response', body: fake_response_body, success?: true)
    allow(Faraday).to receive(:get).and_return(fake_response)

    get '/load-exams'

    expect(last_response.status).to eq 200
    expect(last_response.content_type).to include 'application/json'
    expect(last_response.body).to be_empty
  end

  it 'responds with error' do
    fake_response = double('Faraday::Response', status: 500, body: '[]', success?: false)
    allow(Faraday).to receive(:get).and_return(fake_response)

    get '/load-exams'

    expect(last_response.status).to eq 500
  end
end
