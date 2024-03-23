require 'csv'
require 'benchmark'
require_relative '../patient'
require_relative '../doctor'
require_relative '../lab_exam'
require_relative '../test'
require_relative '../database/database_connection'

class CSVHandler
  class ImportError < StandardError; end

  def self.import(rows)
    raise ImportError.new 'CSV com colunas inválidas' unless valid_csv?(rows)

    puts 'Importando dados...'

    rows.shift

    connection = DatabaseConnection.connect

    time = Benchmark.measure do
      begin
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
      rescue PG::DataException
        raise ImportError.new 'CSV com dados incompletos'
      ensure
        connection.close if connection
      end
    end

    puts 'Dados importados com sucesso'
    puts "Tempo de execução: #{time.real}"
  end

  def self.valid_csv?(rows)
    valid_csv_header = [
      "cpf", "nome paciente", "email paciente", "data nascimento paciente", "endereço/rua paciente",
      "cidade paciente", "estado patiente", "crm médico", "crm médico estado", "nome médico", "email médico",
      "token resultado exame", "data exame", "tipo exame", "limites tipo exame", "resultado tipo exame"
    ]

    return false unless rows.first == valid_csv_header
    true
  end
end
