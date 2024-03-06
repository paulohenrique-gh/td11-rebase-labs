require 'csv'
require_relative 'lib/patient'
require_relative 'lib/doctor'
require_relative 'lib/lab_exam'
require_relative 'lib/test'

rows = CSV.read('./data.csv', col_sep: ';')
rows.shift

puts 'Importando dados...'

rows.each do |row|
  cpf, name, email, birthdate, address, city, state = row[0..6]
  patient = Patient.find_by(cpf:)[0]
  patient ||= Patient.create(cpf:, name:, email:, birthdate:, address:, city:, state:)

  crm, crm_state, name, email = row[7..10]
  doctor = Doctor.find_by(crm:, crm_state:)[0]
  doctor ||= Doctor.create(crm:, crm_state:, name:, email:)

  result_token, result_date = row[11..12]
  lab_exam = LabExam.find_by(result_token:)[0]
  lab_exam ||= LabExam.create(patient_id: patient.id, doctor_id: doctor.id,
                              result_token:, result_date:)

  type, type_limits, type_results = row[13..15]
  Test.create(lab_exam_id: lab_exam.id, type:, type_limits:, type_results:)
end

puts 'Dados importados com sucesso'
