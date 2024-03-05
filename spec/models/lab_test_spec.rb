require 'spec_helper'
require 'lab_test'
require 'patient'
require 'doctor'

RSpec.describe LabTest do
  it 'returns the correct attribute values' do
    patient = Patient.create(cpf: '048.445.170-88', name: 'Renato Barbosa',
                             email: 'renato.barbosa@ebert-quigley.com',
                             birthdate: '1999-03-19', address: '192 Rua Pedras',
                             city: 'Ituverava', state: 'Alagoas')
    doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI',
                           name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz')

    lab_test = LabTest.new(patient_id: patient.id, doctor_id: doctor.id, results_token: 'IQCZ17',
                           date: '2022-11-04', type: 'Leucócitos',
                           type_limits: '52-81', type_results: '89')

    expect(lab_test.patient_id).to eq patient.id
    expect(lab_test.doctor_id).to eq doctor.id
    expect(lab_test.results_token).to eq 'IQCZ17'
    expect(lab_test.date).to eq '2022-11-04'
    expect(lab_test.type).to eq 'Leucócitos'
    expect(lab_test.type_limits).to eq '52-81'
    expect(lab_test.type_results).to eq '89'
  end

  context '.create' do
    it 'saves test in the database and generates ID' do
      patient = Patient.create(cpf: '048.445.170-88', name: 'Renato Barbosa',
                              email: 'renato.barbosa@ebert-quigley.com',
                              birthdate: '1999-03-19', address: '192 Rua Pedras',
                              city: 'Ituverava', state: 'Alagoas')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI',
                            name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz')

      lab_test = LabTest.create(patient_id: patient.id, doctor_id: doctor.id, results_token: 'IQCZ17',
                                date: '2022-11-04', type: 'Leucócitos',
                                type_limits: '52-81', type_results: '89')


      expect(lab_test.id).not_to be_nil
      expect(lab_test.patient_id).to eq patient.id
      expect(lab_test.doctor_id).to eq doctor.id
      expect(lab_test.results_token).to eq 'IQCZ17'
      expect(lab_test.date).to eq '2022-11-04'
      expect(lab_test.type).to eq 'Leucócitos'
      expect(lab_test.type_limits).to eq '52-81'
      expect(lab_test.type_results).to eq '89'
    end
  end

  context '.find_by' do
    it 'returns the test according to given parameter' do
      patient = Patient.create(cpf: '048.445.170-88', name: 'Renato Barbosa',
                              email: 'renato.barbosa@ebert-quigley.com',
                              birthdate: '1999-03-19', address: '192 Rua Pedras',
                              city: 'Ituverava', state: 'Alagoas')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI',
                             name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz')

      lab_test_one = LabTest.create(patient_id: patient.id, doctor_id: doctor.id, results_token: 'IQCZ17',
                                    date: '2022-11-04', type: 'Leucócitos',
                                    type_limits: '52-81', type_results: '89')
      lab_test_one = LabTest.create(patient_id: patient.id, doctor_id: doctor.id, results_token: 'MK9O9Z',
                                    date: '2022-10-30', type: 'Plaquetas',
                                    type_limits: '15-50', type_results: '40')

      tests = LabTest.find_by(patient_id: patient.id)

      expect(tests.class).to eq Array
      expect(tests.count).to eq 2
      expect(tests[0].date).to eq '2022-11-04'
      expect(tests[1].date).to eq '2022-10-30'
    end
  end
end
