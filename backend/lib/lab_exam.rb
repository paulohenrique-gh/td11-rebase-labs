require_relative 'base_model'
require 'benchmark'

class LabExam < BaseModel
  attr_accessor :id, :patient_id, :doctor_id, :result_token, :result_date

  def initialize(id: nil, patient_id:, doctor_id:, result_token:, result_date:)
    @id = id
    @patient_id = patient_id
    @doctor_id = doctor_id
    @result_token = result_token
    @result_date = result_date
  end

  def self.exams_as_json(token = nil)
    conn = DatabaseConnection.connect

    results_collection = {}

    results = if token
                conn.exec_params(sql_join_string << 'WHERE exam_result_token = $1', [token]).entries
              else
                conn.exec(sql_join_string << ';').entries
              end
    conn.close if conn

    return results_collection if results.empty?

    results.each do |row|
      current_token = row['exam_result_token']

      results_collection[current_token] ||= {
        exam_result_token: row['exam_result_token'],
        exam_result_date: row['exam_result_date'],
        patient: row.slice(*row.keys[2..8]),
        doctor: row.slice(*row.keys[9..12]),
        tests: []
      }

      results_collection[current_token][:tests] << row.slice(*row.keys[13..15])
    end

    return results_collection[token].to_json if token

    results_collection.values.to_json
  end

  # def self.exam_by_token(result_token)
    # conn = DatabaseConnection.connect

    # results = conn.exec_params(sql_join_string, [result_token]).entries

    # conn.close if conn

    # exam_data = results.first.slice(*results.first.keys[0..1])
    # exam_data[:patient] = results.first.slice(*results.first.keys[2..8])
    # exam_data[:doctor] = results.first.slice(*results.first.keys[9..12])
    # exam_data[:tests] = results.map do |result|
      # result.slice('test_type', 'test_type_limits', 'test_type_results')
    # end

    # exam_data
  # end

  private

  def self.sql_join_string
    "SELECT
        exam_result_token, exam_result_date, patient_cpf, patient_name,
        patient_email, patient_birthdate, patient_address, patient_city,
        patient_state, doctor_crm, doctor_crm_state, doctor_name, doctor_email,
        test_type, test_type_limits, test_type_results
     FROM lab_exams
     JOIN patients ON exam_patient_id = patient_id
     JOIN doctors ON exam_doctor_id = doctor_id
     JOIN tests ON exam_id = test_lab_exam_id "
  end

  def self.format_exam_hash(query_results)
    format_hash = {}

  end

  def self.entity_name
    'exam'
  end

  def self.table_name
    'lab_exams'
  end
end
