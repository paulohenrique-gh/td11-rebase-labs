require_relative 'database/database_connection'

class LabTest
  def initialize(id: nil, patient_cpf:, patient_name:, patient_email:, patient_birthdate:,
                 patient_address:, patient_city:, patient_state:, doctor_crm:, doctor_crm_state:,
                 doctor_name:, doctor_email:, test_results_token:, test_date:, test_type:,
                 test_type_limits:, test_type_results:)
    @id = id
    @patient_cpf = patient_cpf
    @patient_name = patient_name
    @patient_email = patient_email
    @patient_birthdate = patient_birthdate
    @patient_address = patient_address
    @patient_city = patient_city
    @patient_state = patient_state
    @doctor_crm = doctor_crm
    @doctor_crm_state = doctor_crm_state
    @doctor_name = doctor_name
    @doctor_email = doctor_email
    @test_results_token = test_results_token
    @test_date = test_date
    @test_type = test_type
    @test_type_limits = test_type_limits
    @test_type_results = test_type_results
  end

  def self.import_data_from_csv(rows)
    sql_string = "
      INSERT INTO lab_tests
      (patient_cpf, patient_name, patient_email, patient_birthdate, patient_address,
       patient_city, patient_state, doctor_crm, doctor_crm_state, doctor_name, doctor_email,
       test_results_token, test_date, test_type, test_type_limits, test_type_results)
      VALUES
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
      RETURNING *
    "

    conn = DatabaseConnection.connect

    rows.each do |row|
      lab_test = conn.exec(sql_string, row)
    end

    conn.close if conn
  end

  def self.all_as_json
    conn = DatabaseConnection.connect

    results = conn.exec("SELECT * FROM lab_tests").entries

    translated_attributes = ['id', 'cpf', 'nome_paciente', 'email_paciente', 'data_nascimento_paciente',
                             'endereco_rua_paciente', 'cidade_paciente', 'estado_paciente', 'crm_medico',
                             'crm_medico_estado', 'nome_medico', 'email_medico', 'token_resultado_exame',
                             'data_exame', 'tipo_exame', 'limites_tipo_exame', 'resultado_tipo_exame']

    results.each do |result|
      result.transform_keys!.with_index { |_, i| translated_attributes[i] }
    end

    conn.close if conn

    results.to_json
  end
end
