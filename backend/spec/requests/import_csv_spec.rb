require 'spec_helper'

describe "POST '/import'" do
  it 'success when file type is supported' do
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

    fake_csv = 'spec/support/test.csv'
    spy_import_csv_job = spy('ImportCsvJob')
    stub_const('ImportCsvJob', spy_import_csv_job)

    allow(CSV).to receive(:read).and_return(fake_data)

    post '/import', file: Rack::Test::UploadedFile.new(fake_csv, 'text/csv')

    expect(ImportCsvJob).to have_received(:perform_async).with(fake_data)
    expect(last_response.content_type).to include 'application/json'
    json_response = JSON.parse(last_response.body, symbolize_names: true)
    expect(json_response[:message]).to eq 'Processing file.'
  end

  it 'returns an error if file type is not supported' do
    txt_file = 'spec/support/test.txt'

    post '/import', file: Rack::Test::UploadedFile.new(txt_file, 'text/plain')

    expect(last_response.status).to eq 422
    json_response = JSON.parse(last_response.body, symbolize_names: true)
    expect(json_response[:error]).to eq 'File type is not CSV.'
  end

  it 'returns error when there is no file' do
    post '/import'

    expect(last_response.status).to eq 400
    json_response = JSON.parse(last_response.body, symbolize_names: true)
    expect(json_response[:error]).to eq 'The request does not contain any file.'
  end
end
