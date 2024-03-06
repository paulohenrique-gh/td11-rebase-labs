require 'spec_helper'
require 'patient'
require 'doctor'
require 'lab_exam'
require 'test'

RSpec.describe Test do
  it 'returns the correct attribute values' do
    patient = Patient.create(cpf: '048.445.170-88', name: 'Renato Barbosa',
                             email: 'renato.barbosa@ebert-quigley.com',
                             birthdate: '1999-03-19', address: '192 Rua Pedras',
                             city: 'Ituverava', state: 'Alagoas')
    doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI',
                           name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz')
    lab_exam = LabExam.create(patient_id: patient.id, doctor_id: doctor.id,
                              result_token: 'IQCZ17', result_date: '2022-11-04')

    test = Test.new(lab_exam_id: lab_exam.id, type: 'leucócitos',
                    type_limits: '9-61', type_results: '75')

    expect(test.lab_exam_id).to eq lab_exam.id
    expect(test.type).to eq 'leucócitos'
    expect(test.type_limits).to eq '9-61'
    expect(test.type_results).to eq '75'
  end
end
