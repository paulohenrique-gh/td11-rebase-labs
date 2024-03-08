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

  def self.all_as_json
    conn = DatabaseConnection.connect

    full_results = {}

    conn.exec(sql_join_string).each do |row|
      exam_token = row['exam_result_token']

      full_results[exam_token] ||= {
        exam_result_token: row['exam_result_token'],
        exam_result_date: row['exam_result_date'],
        patient: patient_data_from_query(row),
        doctor: doctor_data_from_query(row),
        tests: []
      }

      full_results[exam_token][:tests] << test_data_from_query(row)
    end

    conn.close if conn
    full_results.values.to_json
  end

  def self.exam_by_token_as_json(result_token)
    conn = DatabaseConnection.connect

    results = conn.exec_params(sql_join_string << 'WHERE exam_result_token = $1', [result_token]).entries

    conn.close if conn

    exam_json = results.first.slice(*results.first.keys[0..1])
    exam_json[:patient] = results.first.slice(*results.first.keys[2..8])
    exam_json[:doctor] = results.first.slice(*results.first.keys[9..12])
    exam_json[:tests] = results.map do |result|
      result.slice('test_type', 'test_type_limits', 'test_type_results')
    end

    exam_json.to_json
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

  def self.patient_data_from_query(row)
    {
      patient_cpf: row['patient_cpf'],
      patient_name: row['patient_name'],
      patient_email: row['patient_email'],
      patient_birthdate: row['patient_birthdate'],
      patient_address: row['patient_address'],
      patient_city: row['patient_city'],
      patient_state: row['patient_state']
    }
  end

  def self.doctor_data_from_query(row)
    {
      doctor_crm: row['doctor_crm'],
      doctor_crm_state: row['doctor_crm_state'],
      doctor_name: row['doctor_name'],
      doctor_email: row['doctor_email']
    }
  end

  def self.test_data_from_query(row)
    {
      test_type: row['test_type'],
      test_type_limits: row['test_type_limits'],
      test_type_results: row['test_type_results']
    }
  end

  def self.entity_name
    'exam'
  end

  def self.table_name
    'lab_exams'
  end
end
