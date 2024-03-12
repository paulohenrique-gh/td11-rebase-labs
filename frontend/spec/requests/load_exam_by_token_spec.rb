require 'spec_helper'

describe 'GET /load-exams/:token' do
  it 'returns one exam according to token' do
    fake_response_body = {
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
    }.to_json
    fake_response = double('Faraday::Response', body: fake_response_body, success?: true)
    allow(Faraday).to receive(:get).and_return(fake_response)

    get '/load-exams/IQCZ17'

    expect(last_response.status).to eq 200
    json_response = JSON.parse(last_response.body, symbolize_names: true)
    expect(json_response.class).to eq Hash
    expect(json_response[:exam_result_token]).to eq 'IQCZ17'
  end

  it 'responds with error' do
    fake_response = double('Faraday::Response', status: 500, success?: false)
    allow(Faraday).to receive(:get).and_return(fake_response)

    get '/load-exams/KD85DC'

    expect(last_response.status).to eq 500
  end
end
