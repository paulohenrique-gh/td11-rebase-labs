require 'spec_helper'

describe "GET '/tests'" do
  it 'returns list of exams' do
    fake_data = [
      ['cpf',
       'nome paciente',
       'email paciente',
       'data nascimento paciente',
       'endereço/rua paciente',
       'cidade paciente',
       'estado patiente',
       'crm médico',
       'crm médico estado',
       'nome médico',
       'email médico',
       'token resultado exame',
       'data exame',
       'tipo exame',
       'limites tipo exame',
       'resultado tipo exame'],
      ['048.445.170-88',
       'Renato Barbosa',
       'renato.barbosa@ebert-quigley.com',
       '1999-03-19',
       '192 Rua Pedras',
       'Ituverava',
       'Alagoas',
       'B000BJ20J4',
       'PI',
       'Célia Ferreira',
       'Célia@wisozk.biz',
       'IQCZ17',
       '2023-08-08',
       'hemácias',
       '45-52',
       '97'],
      ['048.973.170-88',
       'Emilly Batista Neto',
       'gerald.crona@ebert-quigley.com',
       '2001-03-11',
       '165 Rua Rafaela',
       'Ituverava',
       'Alagoas',
       'B0009A20A5',
       'PI',
       'Maria Luiza Pires',
       'denna@wisozk.biz',
       'IQCZ99',
       '2021-08-05',
       'leucócitos',
       '9-61',
       '89']]
    allow(CSV).to receive(:read).and_return(fake_data)

    require_relative '../../import_from_csv'
    get '/tests'

    expect(last_response.status).to eq 200
    json_response = JSON.parse(last_response.body)
    expect(json_response.class).to eq Array
    expect(json_response.size).to eq 2
    expect(json_response.first['cpf']).to eq '048.445.170-88'
    expect(json_response.first['nome_paciente']).to eq 'Renato Barbosa'
    expect(json_response.first['email_paciente']).to eq 'renato.barbosa@ebert-quigley.com'
    expect(json_response.first['data_nascimento_paciente']).to eq '1999-03-19'
    expect(json_response.first['endereco_rua_paciente']).to eq '192 Rua Pedras'
    expect(json_response.first['cidade_paciente']).to eq 'Ituverava'
    expect(json_response.first['estado_paciente']).to eq 'Alagoas'
    expect(json_response.first['crm_medico']).to eq 'B000BJ20J4'
    expect(json_response.first['crm_medico_estado']).to eq 'PI'
    expect(json_response.first['nome_medico']).to eq 'Célia Ferreira'
    expect(json_response.first['email_medico']).to eq 'Célia@wisozk.biz'
    expect(json_response.first['token_resultado_exame']).to eq 'IQCZ17'
    expect(json_response.first['data_exame']).to eq '2023-08-08'
    expect(json_response.first['tipo_exame']).to eq 'hemácias'
    expect(json_response.first['limites_tipo_exame']).to eq '45-52'
    expect(json_response.first['resultado_tipo_exame']).to eq '97'

    expect(json_response.last['cpf']).to eq '048.973.170-88'
    expect(json_response.last['nome_paciente']).to eq 'Emilly Batista Neto'
    expect(json_response.last['email_paciente']).to eq 'gerald.crona@ebert-quigley.com'
    expect(json_response.last['data_nascimento_paciente']).to eq '2001-03-11'
    expect(json_response.last['endereco_rua_paciente']).to eq '165 Rua Rafaela'
    expect(json_response.last['cidade_paciente']).to eq 'Ituverava'
    expect(json_response.last['estado_paciente']).to eq 'Alagoas'
    expect(json_response.last['crm_medico']).to eq 'B0009A20A5'
    expect(json_response.last['crm_medico_estado']).to eq 'PI'
    expect(json_response.last['nome_medico']).to eq 'Maria Luiza Pires'
    expect(json_response.last['email_medico']).to eq 'denna@wisozk.biz'
    expect(json_response.last['token_resultado_exame']).to eq 'IQCZ99'
    expect(json_response.last['data_exame']).to eq '2021-08-05'
    expect(json_response.last['tipo_exame']).to eq 'leucócitos'
    expect(json_response.last['limites_tipo_exame']).to eq '9-61'
    expect(json_response.last['resultado_tipo_exame']).to eq '89'
  end
end
