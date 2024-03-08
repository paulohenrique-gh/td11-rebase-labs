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

    results = if token
                conn.exec_params(sql_join_string << 'WHERE exam_result_token = $1', [token]).entries
              else
                conn.exec(sql_join_string << ';').entries
              end
    conn.close if conn

    return results.to_json if results.empty?
    return formatted_exams_hash(results)[token].to_json if token

    formatted_exams_hash(results).values.to_json
  end

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

  def self.formatted_exams_hash(query_results)
    exams_hash = {}

    query_results.each do |row|
      exams_hash[row['exam_result_token']] ||= {
        exam_result_token: row['exam_result_token'],
        exam_result_date: row['exam_result_date'],
        patient: row.slice(*row.keys[2..8]),
        doctor: row.slice(*row.keys[9..12]),
        tests: []
      }

      exams_hash[row['exam_result_token']][:tests] << row.slice(*row.keys[13..15])
    end

    exams_hash
  end

  def self.entity_name
    'exam'
  end

  def self.table_name
    'lab_exams'
  end
end
