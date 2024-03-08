require 'spec_helper'
require 'doctor'
require 'lab_exam'
require 'patient'
require 'test'

describe 'GET /tests/:token' do
  it 'returns exam data according to token' do
    patient_one = Patient.create({ cpf: '048.445.170-88', name: 'Renato Barbosa',
                                  email: 'renato.barbosa@ebert-quigley.com',
                                  birthdate: '1999-03-19', address: '192 Rua Pedras',
                                  city: 'Ituverava', state: 'Alagoas' })
    patient_two = Patient.create({ cpf: '928.384.992.02', name: 'Antonio Jackson',
                                  email: 'antonio.jackson@ebert-quigley.com',
                                  birthdate: '1991-05-19', address: '112 Rua do Pecado',
                                  city: 'Ituverava', state: 'Alagoas' })
    doctor_one = Doctor.create({ crm: 'B000BJ20J4', crm_state: 'PI',
                                name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz' })
    doctor_two = Doctor.create({ crm: 'P91IKM9114', crm_state: 'PI',
                                name: 'Joao Carlos Azevedo', email: 'joao.azevedo@wisozk.biz' })

    lab_exam_one = LabExam.create({ patient_id: patient_one.id, doctor_id: doctor_two.id,
                                  result_token: 'IQCZ17', result_date: '2022-11-04' })
    lab_exam_two = LabExam.create({ patient_id: patient_two.id, doctor_id: doctor_one.id,
                                  result_token: 'MK9O9Z', result_date: '2022-10-30' })

    test_one = Test.create({ lab_exam_id: lab_exam_one.id, type: 'leucócitos',
                            type_limits: '9-61', type_results: '75' })
    test_two = Test.create({ lab_exam_id: lab_exam_one.id, type: 'hemácias',
                            type_limits: '45-52', type_results: '48' })
    test_three = Test.create({ lab_exam_id: lab_exam_two.id, type: 'plaquetas',
                              type_limits: '11-93', type_results: '67' })
    test_four = Test.create({ lab_exam_id: lab_exam_two.id, type: 'hdl',
                            type_limits: '19-75', type_results: '3' })

    get '/tests/IQCZ17'

    expect(last_response.status).to eq 200
    expect(last_response.content_type).to include 'application/json'
    json_response = JSON.parse(last_response.body, symbolize_names: true)

  end
end
