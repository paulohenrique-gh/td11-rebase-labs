require 'spec_helper'
require 'patient'

RSpec.describe Patient do
  it 'returns the correct attribute values' do
    patient = Patient.new(cpf: '048.445.170-88', name: 'Renato Barbosa',
                          email: 'renato.barbosa@ebert-quigley.com',
                          birthdate: '1999-03-19', address: '192 Rua Pedras',
                          city: 'Ituverava', state: 'Alagoas')

    expect(patient.cpf).to eq '048.445.170-88'
    expect(patient.name).to eq 'Renato Barbosa'
    expect(patient.email).to eq 'renato.barbosa@ebert-quigley.com'
    expect(patient.birthdate).to eq '1999-03-19'
    expect(patient.address).to eq '192 Rua Pedras'
    expect(patient.city).to eq 'Ituverava'
    expect(patient.state).to eq 'Alagoas'
  end

  context '.create' do
    it 'saves patient in the database and generates ID' do
      patient = Patient.create(cpf: '048.445.170-88', name: 'Renato Barbosa',
                               email: 'renato.barbosa@ebert-quigley.com',
                               birthdate: '1999-03-19', address: '192 Rua Pedras',
                               city: 'Ituverava', state: 'Alagoas')

      expect(Patient.all.count).to eq 1
      expect(patient.id).not_to be_nil
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

  context '.find_by' do
    it 'returns an array with patients according to given parameter' do
      Patient.create(cpf: '048.445.170-88', name: 'Renato Barbosa',
                     email: 'renato.barbosa@ebert-quigley.com',
                     birthdate: '1999-03-19', address: '192 Rua Pedras',
                     city: 'Ituverava', state: 'Alagoas')

      patients = Patient.find_by(cpf: '048.445.170-88')

      expect(patients.class).to eq Array
      expect(patients[0].name).to eq 'Renato Barbosa'
    end

    it 'returns an empty array when there is no result' do
      patients = Patient.find_by(cpf: '992.392.123-87')

      expect(patients).to eq []
    end
  end
end
