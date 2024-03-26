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

    first_exam = {
      exam_result_token: 'IQCZ17',
      exam_result_date: '2023-08-08',
      patient: {
        patient_cpf: '048.445.170-88',
        patient_name: 'Renato Barbosa',
        patient_email: 'renato.barbosa@ebert-quigley.com',
        patient_birthdate: '1999-03-19',
        patient_address: '192 Rua Pedras',
        patient_city: 'Ituverava',
        patient_state: 'Alagoas'
      },
      doctor: {
        doctor_crm: 'B000BJ20J4',
        doctor_crm_state: 'PI',
        doctor_name: 'Célia Ferreira',
        doctor_email: 'Célia@wisozk.biz',
      },
      tests: [
        {
          test_type: 'hemácias',
          test_type_limits: '45-52',
          test_type_results: '97'
        }
      ]
    }

    second_exam = {
      exam_result_token: 'IQCZ99',
      exam_result_date: '2021-08-05',
      patient: {
        patient_cpf: '048.973.170-88',
        patient_name: 'Emilly Batista Neto',
        patient_email: 'gerald.crona@ebert-quigley.com',
        patient_birthdate: '2001-03-11',
        patient_address: '165 Rua Rafaela',
        patient_city: 'Ituverava',
        patient_state: 'Alagoas'
      },
      doctor: {
        doctor_crm: 'B0009A20A5',
        doctor_crm_state: 'PI',
        doctor_name: 'Maria Luiza Pires',
        doctor_email: 'denna@wisozk.biz',
      },
      tests: [
        {
          test_type: 'leucócitos',
          test_type_limits: '9-61',
          test_type_results: '89'
        }
      ]
    }
    
    expected_response = [first_exam, second_exam]

    expect(last_response.status).to eq 200
    expect(last_response.content_type).to include 'application/json'
    json_response = JSON.parse(last_response.body, symbolize_names: true)
    expect(json_response.class).to eq Array
    expect(json_response.size).to eq 2
    expect(json_response).to eq expected_response
  end

  it 'returns empty array before importing from CSV' do
    get '/tests'

    expect(last_response.status).to eq 200
    json_response = JSON.parse(last_response.body)
    expect(json_response.class).to eq Array
    expect(json_response).to be_empty
  end
end
