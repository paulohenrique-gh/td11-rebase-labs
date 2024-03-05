require_relative 'base_model'

class LabTest < BaseModel
  attr_accessor :id, :patient_id, :doctor_id, :results_token, :date, :type, :type_limits, :type_results

  def initialize(id: nil, patient_id:, doctor_id:, results_token:, date:,
                 type:, type_limits:, type_results: nil)
    @id = id
    @patient_id = patient_id
    @doctor_id = doctor_id
    @results_token = results_token
    @date = date
    @type = type
    @type_limits = type_limits
    @type_results = type_results
  end

  def self.all_as_json
    conn = DatabaseConnection.connect

    results = conn.exec("
      SELECT
        lab_tests.test_id AS id,
        patients.patient_cpf AS cpf,
        patients.patient_name AS nome_paciente,
        patients.patient_email AS email_paciente,
        patients.patient_birthdate AS data_nascimento_paciente,
        patients.patient_address AS endereco_rua_paciente,
        patients.patient_city AS cidade_paciente,
        patients.patient_state AS estado_paciente,
        doctors.doctor_crm AS crm_medico,
        doctors.doctor_crm_state AS crm_medico_estado,
        doctors.doctor_name AS nome_medico,
        doctors.doctor_email AS email_medico,
        lab_tests.test_results_token AS token_resultado_exame,
        lab_tests.test_date AS data_exame,
        lab_tests.test_type AS tipo_exame,
        lab_tests.test_type_limits AS limites_tipo_exame,
        lab_tests.test_type_results AS resultado_tipo_exame
      FROM lab_tests
      JOIN patients ON (patients.patient_id = lab_tests.test_patient_id)
      JOIN doctors ON (doctors.doctor_id = lab_tests.test_doctor_id);
    ")

    conn.close if conn
    results.entries.to_json
  end

  private

  def self.entity_name
    'test'
  end

  def self.table_name
    'lab_tests'
  end
end
