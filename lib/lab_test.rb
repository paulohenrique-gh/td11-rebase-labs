class LabTest
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

  def self.create(patient_id:, doctor_id:, results_token:, date:, type:, type_limits:, type_results: nil)
    sql_string = "
      INSERT INTO lab_tests (test_patient_id, test_doctor_id, test_results_token, test_date, test_type,
        test_type_limits, test_type_results)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *;
    "

    conn = DatabaseConnection.connect
    result = conn.exec_params(sql_string, [patient_id, doctor_id, results_token,
                                           date, type, type_limits, type_results])

    return instantiate_from_db(result.entries[0]) if result.any?
  rescue PG::UniqueViolation
    return nil
  ensure
    conn.close if conn
  end

  def self.find_by(options = {})
    conn = DatabaseConnection.connect
    query = query_builder(options)
    results = conn.exec_params(query[:sql_query], query[:parameters])

    return results.entries.map { |result| instantiate_from_db(result) } if results.any?
    []
  end

  def self.all
    conn = DatabaseConnection.connect
    entries = conn.exec('SELECT * FROM lab_tests;').entries
    conn.close if conn

    entries.map do |entry|
      data_hash = entry.transform_keys { |k| k.split('_')[1..-1].join('_').to_sym }
      new(**data_hash)
    end
  end

  private

  def self.query_builder(options)
    sql_query = 'SELECT * FROM lab_tests WHERE '
    parameters = []

    options.each_with_index do |(k, v), index|
      sql_query << "test_#{k} = $#{index + 1}"
      sql_query << ' AND ' if options.size > index + 1
      parameters << v
    end

    { sql_query:, parameters: }
  end

  def self.instantiate_from_db(query_result)
    test_data_hash = query_result.transform_keys { |k| k.split('_')[1..-1].join('_').to_sym }
    test = new(**test_data_hash)
  end
end
