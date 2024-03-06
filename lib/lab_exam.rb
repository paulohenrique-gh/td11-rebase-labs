require_relative 'base_model'

class LabExam < BaseModel
  attr_accessor :id, :patient_id, :doctor_id, :result_token, :result_date, :type, :type_limits, :type_results

  def initialize(id: nil, patient_id:, doctor_id:, result_token:, result_date:)
    @id = id
    @patient_id = patient_id
    @doctor_id = doctor_id
    @result_token = result_token
    @result_date = result_date
  end

  def self.all_as_json
    conn = DatabaseConnection.connect

    full_results = []

    exams = conn.exec("SELECT * FROM lab_exams;").entries.each do |exam|
      exam_data = exam.slice('exam_result_token', 'exam_result_date')

      patient_data = conn.exec_params("SELECT * FROM patients WHERE patient_id = $1;",
                                       [exam['exam_patient_id']]).entries[0]
      exam_data['patient'] = patient_data.except('patient_id')

      doctor_data = conn.exec_params("SELECT * FROM doctors WHERE doctor_id = $1;",
                                     [exam['exam_doctor_id']]).entries[0]
      exam_data['doctor'] = doctor_data.except('doctor_id')

      tests_data = conn.exec_params("SELECT * FROM tests WHERE test_lab_exam_id = $1;",
                                    [exam['exam_id']])
                       .entries
                       .map { |t| t.except('test_id', 'test_lab_exam_id') }
      exam_data['tests'] = tests_data

      full_results << exam_data
    end

    conn.close if conn
    full_results.to_json
  end

  private

  def self.entity_name
    'exam'
  end

  def self.table_name
    'lab_exams'
  end
end
