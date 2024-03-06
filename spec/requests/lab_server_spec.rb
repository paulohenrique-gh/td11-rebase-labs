require 'spec_helper'
require 'csv'

describe "GET '/tests'" do
  it 'returns list of exams after importing from CSV' do
    fake_data = [
      ['cpf', 'nome paciente', 'email paciente', 'data nascimento paciente',
       'endereço/rua paciente', 'cidade paciente', 'estado patiente',
       'crm médico', 'crm médico estado', 'nome médico', 'email médico',
       'token resultado exame', 'data exame', 'tipo exame', 'limites tipo exame',
       'resultado tipo exame'],
      ['048.445.170-88', 'Renato Barbosa', 'renato.barbosa@ebert-quigley.com',
       '1999-03-19', '192 Rua Pedras', 'Ituverava', 'Alagoas', 'B000BJ20J4',
       'PI', 'Célia Ferreira', 'Célia@wisozk.biz', 'IQCZ17', '2023-08-08',
       'hemácias', '45-52', '97'],
      ['048.973.170-88', 'Emilly Batista Neto', 'gerald.crona@ebert-quigley.com',
       '2001-03-11', '165 Rua Rafaela', 'Ituverava', 'Alagoas', 'B0009A20A5',
       'PI', 'Maria Luiza Pires', 'denna@wisozk.biz', 'IQCZ99', '2021-08-05',
       'leucócitos', '9-61', '89']
    ]
    allow(CSV).to receive(:read).and_return(fake_data)

    load 'import_from_csv.rb'
    get '/tests'

    expect(last_response.status).to eq 200
    json_response = JSON.parse(last_response.body, symbolize_names: true)
    expect(json_response.class).to eq Array
    expect(json_response.size).to eq 2
    expect(json_response.first[:exam_result_token]).to eq 'IQCZ17'
    expect(json_response.first[:exam_result_date]).to eq '2023-08-08'
    expect(json_response.first[:patient][:patient_cpf]).to eq '048.445.170-88'
    expect(json_response.first[:patient][:patient_name]).to eq 'Renato Barbosa'
    expect(json_response.first[:patient][:patient_email]).to eq 'renato.barbosa@ebert-quigley.com'
    expect(json_response.first[:patient][:patient_birthdate]).to eq '1999-03-19'
    expect(json_response.first[:patient][:patient_address]).to eq '192 Rua Pedras'
    expect(json_response.first[:patient][:patient_city]).to eq 'Ituverava'
    expect(json_response.first[:patient][:patient_state]).to eq 'Alagoas'
    expect(json_response.first[:doctor][:doctor_crm]).to eq 'B000BJ20J4'
    expect(json_response.first[:doctor][:doctor_crm_state]).to eq 'PI'
    expect(json_response.first[:doctor][:doctor_name]).to eq 'Célia Ferreira'
    expect(json_response.first[:doctor][:doctor_email]).to eq 'Célia@wisozk.biz'
    expect(json_response.first[:tests].first[:test_type]).to eq 'hemácias'
    expect(json_response.first[:tests].first[:test_type_limits]).to eq '45-52'
    expect(json_response.first[:tests].first[:test_type_results]).to eq '97'

    expect(json_response.last[:exam_result_token]).to eq 'IQCZ99'
    expect(json_response.last[:exam_result_date]).to eq '2021-08-05'
    expect(json_response.last[:patient][:patient_cpf]).to eq '048.973.170-88'
    expect(json_response.last[:patient][:patient_name]).to eq 'Emilly Batista Neto'
    expect(json_response.last[:patient][:patient_email]).to eq 'gerald.crona@ebert-quigley.com'
    expect(json_response.last[:patient][:patient_birthdate]).to eq '2001-03-11'
    expect(json_response.last[:patient][:patient_address]).to eq '165 Rua Rafaela'
    expect(json_response.last[:patient][:patient_city]).to eq 'Ituverava'
    expect(json_response.last[:patient][:patient_state]).to eq 'Alagoas'
    expect(json_response.last[:doctor][:doctor_crm]).to eq 'B0009A20A5'
    expect(json_response.last[:doctor][:doctor_crm_state]).to eq 'PI'
    expect(json_response.last[:doctor][:doctor_name]).to eq 'Maria Luiza Pires'
    expect(json_response.last[:doctor][:doctor_email]).to eq 'denna@wisozk.biz'
    expect(json_response.last[:tests].first[:test_type]).to eq 'leucócitos'
    expect(json_response.last[:tests].first[:test_type_limits]).to eq '9-61'
    expect(json_response.last[:tests].first[:test_type_results]).to eq '89'
  end

  it 'returns empty array before importing from CSV' do
    get '/tests'

    expect(last_response.status).to eq 200
    json_response = JSON.parse(last_response.body)
    expect(json_response.class).to eq Array
    expect(json_response).to be_empty
  end
end
