require 'csv'
require 'benchmark'
require_relative '../patient'
require_relative '../doctor'
require_relative '../lab_exam'
require_relative '../test'
require_relative '../database/database_connection'

class CSVHandler
  def self.import(rows)
    puts 'Importando dados...'

    rows.shift

    connection = DatabaseConnection.connect

    time = Benchmark.measure do
      connection.transaction do |conn|
        rows.each_with_index do |row|
          close_connection = false

          cpf, name, email, birthdate, address, city, state = row[0..6]
          patient = Patient.find_by({ cpf: }, conn:, close_connection:)[0]
          patient ||= Patient.create({ cpf:, name:, email:, birthdate:, address:, city:, state: },
                                       conn:, close_connection:)

          crm, crm_state, name, email = row[7..10]
          doctor = Doctor.find_by({ crm:, crm_state: }, conn:, close_connection:)[0]
          doctor ||= Doctor.create({ crm:, crm_state:, name:, email: },
                                     conn:, close_connection:)

          result_token, result_date = row[11..12]
          lab_exam = LabExam.find_by({ result_token: }, conn:, close_connection:)[0]
          lab_exam ||= LabExam.create({ patient_id: patient.id, doctor_id: doctor.id,
                                      result_token:, result_date: }, conn:, close_connection:)

          type, type_limits, type_results = row[13..15]
          Test.create({ lab_exam_id: lab_exam.id, type:, type_limits:, type_results: },
                      conn:, close_connection:)
        end
      end
    end

    connection.close if connection

    puts 'Dados importados com sucesso'
    puts "Tempo de execução: #{time.real}"
  end
end
