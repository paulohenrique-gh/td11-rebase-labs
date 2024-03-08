require 'spec_helper'
require 'lab_exam'
require 'patient'
require 'doctor'
require 'test'

RSpec.describe LabExam do
  it 'returns the correct attribute values' do
    patient = Patient.create({ cpf: '048.445.170-88', name: 'Renato Barbosa',
                             email: 'renato.barbosa@ebert-quigley.com',
                             birthdate: '1999-03-19', address: '192 Rua Pedras',
                             city: 'Ituverava', state: 'Alagoas' })
    doctor = Doctor.create({ crm: 'B000BJ20J4', crm_state: 'PI',
                           name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz' })

    lab_exam = LabExam.new(patient_id: patient.id, doctor_id: doctor.id,
                           result_token: 'IQCZ17', result_date: '2022-11-04')

    expect(lab_exam.patient_id).to eq patient.id
    expect(lab_exam.doctor_id).to eq doctor.id
    expect(lab_exam.result_token).to eq 'IQCZ17'
    expect(lab_exam.result_date).to eq '2022-11-04'
  end

  context '.create' do
    it 'saves test in the database and generates ID' do
      patient = Patient.create({ cpf: '048.445.170-88', name: 'Renato Barbosa',
                              email: 'renato.barbosa@ebert-quigley.com',
                              birthdate: '1999-03-19', address: '192 Rua Pedras',
                              city: 'Ituverava', state: 'Alagoas' })
      doctor = Doctor.create({ crm: 'B000BJ20J4', crm_state: 'PI',
                            name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz' })

      lab_exam = LabExam.create({ patient_id: patient.id, doctor_id: doctor.id,
                                result_token: 'IQCZ17', result_date: '2022-11-04' })


      expect(lab_exam.id).not_to be_nil
      expect(lab_exam.patient_id).to eq patient.id
      expect(lab_exam.doctor_id).to eq doctor.id
      expect(lab_exam.result_token).to eq 'IQCZ17'
      expect(lab_exam.result_date).to eq '2022-11-04'
    end
  end

  context '.find_by' do
    it 'returns the tests according to given parameter' do
      patient = Patient.create({ cpf: '048.445.170-88', name: 'Renato Barbosa',
                              email: 'renato.barbosa@ebert-quigley.com',
                              birthdate: '1999-03-19', address: '192 Rua Pedras',
                              city: 'Ituverava', state: 'Alagoas' })
      doctor = Doctor.create({ crm: 'B000BJ20J4', crm_state: 'PI',
                             name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz' })

      lab_exam_one = LabExam.create({ patient_id: patient.id, doctor_id: doctor.id,
                                    result_token: 'IQCZ17', result_date: '2022-11-04' })
      lab_exam_one = LabExam.create({ patient_id: patient.id, doctor_id: doctor.id,
                                    result_token: 'MK9O9Z', result_date: '2022-10-30' })

      exams = LabExam.find_by({ patient_id: patient.id })

      expect(exams.class).to eq Array
      expect(exams.count).to eq 2
      expect(exams[0].result_date).to eq '2022-11-04'
      expect(exams[1].result_date).to eq '2022-10-30'
    end

    it 'returns an empty array when there are no results' do
      tests = LabExam.find_by({ patient_id: 15 })

      expect(tests).to eq []
    end
  end

  context '.exams_as_json' do
    it 'returns all tests in the database as json' do
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

      exams = LabExam.exams_as_json

      json_body = JSON.parse(exams)
      expect(json_body.class).to eq Array
      expect(json_body.count).to eq 2
      expect(json_body[0]['exam_result_token']).to eq 'IQCZ17'
      expect(json_body[1]['exam_result_token']).to eq 'MK9O9Z'
    end

    it 'returns exam json according to token given as argument' do
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

      exam = LabExam.exams_as_json('MK9O9Z')

      json_body = JSON.parse(exam, symbolize_names: true)
      expect(json_body.class).to eq Hash
      expect(json_body[:exam_result_token]).to eq 'MK9O9Z'
      expect(json_body[:patient][:patient_cpf]).to eq '928.384.992.02'
      expect(json_body[:doctor][:doctor_crm]).to eq 'B000BJ20J4'
      expect(json_body[:tests].class).to eq Array
      expect(json_body[:tests].count).to eq 2
    end

    it 'returns an empty array when there are no results' do
      tests = LabExam.exams_as_json

      json_body = JSON.parse(tests)

      expect(json_body.class).to eq Array
      expect(json_body.count).to eq 0
    end
  end
end
