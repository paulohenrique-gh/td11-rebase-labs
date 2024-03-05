require 'database/database_connection'

class Patient
  attr_accessor :id, :cpf, :name, :email, :birthdate, :address, :city, :state

  def initialize(id: nil, cpf:, name:, email:, birthdate:, address:, city:, state:)
    @id = id
    @cpf = cpf
    @name = name
    @email = email
    @birthdate = birthdate
    @address = address
    @city = city
    @state = state
  end

  def self.create(cpf:, name:, email:, birthdate:, address:, city:, state:)
    sql_string = "
      INSERT INTO patients (patient_cpf, patient_name, patient_email, patient_birthdate,
        patient_address, patient_city, patient_state)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *;
    "
    conn = DatabaseConnection.connect
    result = conn.exec_params(sql_string, [cpf, name, email, birthdate, address, city, state])

    return instantiate_from_db(result.entries[0]) if result.any?
  rescue PG::UniqueViolation
    return nil
  ensure
    conn.close if conn
  end

  def self.all
    conn = DatabaseConnection.connect
    patients = conn.exec('SELECT * FROM patients;').entries
    conn.close if conn

    patients.map do |patient|
      patient_data_hash = patient.transform_keys { |k| k.split('_')[1..-1].join('_').to_sym }
      new(**patient_data_hash)
    end
  end

  def self.find_by(options = {})
    conn = DatabaseConnection.connect
    query = query_builder(options)
    result = conn.exec_params(query[:sql_query], query[:parameters])

    return instantiate_from_db(result.entries[0]) if result.any?

    nil
  end

  private

  def self.query_builder(options)
    sql_query = 'SELECT * FROM patients WHERE '
    parameters = []

    options.each_with_index do |(k, v), index|
      sql_query << "patient_#{k} = $#{index + 1}"
      sql_query << ' AND ' if options.size > index + 1
      parameters << v
    end

    { sql_query:, parameters: }
  end

  def self.instantiate_from_db(query_result)
    patient_data_hash = query_result.transform_keys { |k| k.split('_')[1..-1].join('_').to_sym }
    new(**patient_data_hash)
  end
end
