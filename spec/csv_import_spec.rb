require 'spec_helper'

RSpec.describe 'import_from_csv script' do
  it 'imports data from csv do database as expected' do
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
      ['048.445.170-88', 'Renato Barbosa', 'gerald.crona@ebert-quigley.com',
       '2001-03-11', '165 Rua Rafaela', 'Ituverava', 'Alagoas', 'B0009A20A5',
       'PI', 'Maria Luiza Pires', 'denna@wisozk.biz', 'IQCZ99', '2021-08-05',
       'leucócitos', '9-61', '89']
    ]
    allow(CSV).to receive(:read).and_return(fake_data)

    load 'import_from_csv.rb'

    expect(LabExam.all.count).to eq 2
    expect(Test.all.count).to eq 2
    expect(Doctor.all.count).to eq 2
    expect(Patient.all.count).to eq 1
  end
end
