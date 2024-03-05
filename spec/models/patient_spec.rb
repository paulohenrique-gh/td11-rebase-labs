require 'spec_helper'
require 'patient'

RSpec.describe Patient do
  it 'returns the correct attribute values' do
    patient = Patient.new(
      cpf: '048.445.170-88',
      name: 'Renato Barbosa',
      email: 'renato.barbosa@ebert-quigley.com',
      birthdate: '1999-03-19',
      address: '192 Rua Pedras',
      city: 'Ituverava',
      state: 'Alagoas'
    )

    expect(patient.cpf).to eq '048.445.170-88'
    expect(patient.name).to eq 'Renato Barbosa'
    expect(patient.email).to eq 'renato.barbosa@ebert-quigley.com'
    expect(patient.birthdate).to eq '1999-03-19'
    expect(patient.address).to eq '192 Rua Pedras'
    expect(patient.city).to eq 'Ituverava'
    expect(patient.state).to eq 'Alagoas'
  end

  context '.create' do
    it 'saves patient in the database' do
      Patient.create(cpf: '048.445.170-88', name: 'Renato Barbosa',
                     email: 'renato.barbosa@ebert-quigley.com',
                     birthdate: '1999-03-19', address: '192 Rua Pedras',
                     city: 'Ituverava', state: 'Alagoas')

      patient = Patient.all[0]
      expect(patient.cpf).to eq '048.445.170-88'
      expect(patient.name).to eq 'Renato Barbosa'
      expect(patient.email).to eq 'renato.barbosa@ebert-quigley.com'
      expect(patient.birthdate).to eq '1999-03-19'
      expect(patient.address).to eq '192 Rua Pedras'
      expect(patient.city).to eq 'Ituverava'
      expect(patient.state).to eq 'Alagoas'
    end

    it 'does not save two patients with the same cpf' do
      Patient.create(cpf: '048.445.170-88', name: 'Renato Barbosa',
                     email: 'renato.barbosa@ebert-quigley.com',
                     birthdate: '1999-03-19', address: '192 Rua Pedras',
                     city: 'Ituverava', state: 'Alagoas')
      Patient.create(cpf: '048.445.170-88', name: 'Renato Barbosa',
                     email: 'renato.barbosa@ebert-quigley.com',
                     birthdate: '1999-03-19', address: '192 Rua Pedras',
                     city: 'Ituverava', state: 'Alagoas')

      conn = DatabaseConnection.connect
      patients_count = conn.exec('SELECT COUNT (*) FROM patients;').getvalue(0, 0).to_i
      conn.close if conn

      expect(patients_count).to eq 1
    end
  end

  context '.all' do
    it 'returns array with objects from database' do
      Patient.create(cpf: '048.445.170-88', name: 'Renato Barbosa',
                     email: 'renato.barbosa@ebert-quigley.com',
                     birthdate: '1999-03-19', address: '192 Rua Pedras',
                     city: 'Ituverava', state: 'Alagoas')
      Patient.create(cpf: '528.101.449.01', name: 'Raul Geraldo',
                     email: 'raul.geraldo@ebert-quigley.com',
                     birthdate: '1989-03-20', address: '192 Rua Pedras',
                     city: 'Ituverava', state: 'Alagoas')
      Patient.create(cpf: '929.838.828-91', name: 'Taís Nogueira',
                     email: 'tais.nogueira@ebert-quigley.com',
                     birthdate: '2001-11-08', address: '82 Rua da Folha',
                     city: 'Ituverava', state: 'Alagoas')

      patients = Patient.all
      expect(patients.class).to eq Array
      expect(patients.count).to eq 3
      expect(patients[0].cpf).to eq '048.445.170-88'
      expect(patients[1].cpf).to eq '528.101.449.01'
      expect(patients[2].cpf).to eq '929.838.828-91'
    end

    it 'returns an empty array when there is no patient in the database' do
      expect(Patient.all).to eq []
    end
  end

  context '.find_by' do
    it 'returns the patient according to given parameter' do
      Patient.create(cpf: '048.445.170-88', name: 'Renato Barbosa',
                     email: 'renato.barbosa@ebert-quigley.com',
                     birthdate: '1999-03-19', address: '192 Rua Pedras',
                     city: 'Ituverava', state: 'Alagoas')

      patient = Patient.find_by(cpf: '048.445.170-88')

      expect(patient.name).to eq 'Renato Barbosa'
    end

    it 'returns nil when there is no result' do
      patient = Patient.find_by(cpf: '992.392.123-87')

      expect(patient).to be_nil
    end
  end
end
