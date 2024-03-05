require 'database/database_connection'

class Doctor
  attr_accessor :id, :crm, :crm_state, :name, :email

  def initialize(id: nil, crm:, crm_state:, name:, email:)
    @id = id
    @crm = crm
    @crm_state = crm_state
    @name = name
    @email = email
  end

  def self.create(crm:, crm_state:, name:, email:)
    sql_string = "
      INSERT INTO doctors (doctor_crm, doctor_crm_state, doctor_name, doctor_email)
      VALUES ($1, $2, $3, $4)
      RETURNING *;
    "
    conn = DatabaseConnection.connect
    result = conn.exec_params(sql_string, [crm, crm_state, name, email])

    return instantiate_from_db(result.entries[0]) if result.any?
  rescue PG::UniqueViolation
    return nil
  ensure
    conn.close if conn
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
    sql_query = 'SELECT * FROM doctors WHERE '
    parameters = []

    options.each_with_index do |(k, v), index|
      sql_query << "doctor_#{k} = $#{index + 1}"
      sql_query << ' AND ' if options.size > index + 1
      parameters << v
    end

    { sql_query:, parameters: }
  end

  def self.instantiate_from_db(query_result)
    doctor_data_hash = query_result.transform_keys { |k| k.split('_')[1..-1].join('_').to_sym }
    new(**doctor_data_hash)
  end
end
