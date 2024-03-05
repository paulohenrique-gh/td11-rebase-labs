require 'database/database_connection'

class BaseModel
  def self.create(**attributes)
    sql_string = "
      INSERT INTO #{table_name}
      (#{model_attributes_to_db_attributes(attributes).keys.join(', ')})
      VALUES (#{attributes.values.map.with_index { |_, index| "$#{index + 1}" }.join(', ')})
      RETURNING *;
    "

    conn = DatabaseConnection.connect
    result = conn.exec_params(sql_string, attributes.values)

    return instantiate_from_db(result.entries[0]) if result.any?
  rescue PG::UniqueViolation
    return nil
  ensure
    conn.close if conn
  end

  def self.all
    conn = DatabaseConnection.connect
    entries = conn.exec("SELECT * FROM #{table_name}").entries
    conn.close

    return entries if entries.empty?

    entries.map do |entry|
      instantiate_from_db(entry)
    end
  end

  def self.find_by(options = {})
    conn = DatabaseConnection.connect
    query = select_query_builder(options)
    results = conn.exec_params(query[:sql_query], query[:parameters])

    return results.entries if results.entries.empty?

    results.entries.map { |result| instantiate_from_db(result) }
  end

  protected

  def self.entity_name
    name.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .downcase
  end

  def self.table_name
    entity_name << 's'
  end

  def self.model_attributes_to_db_attributes(attributes)
    attributes.transform_keys { |att| "#{entity_name}_" << att.to_s }
  end

  def self.select_query_builder(options)
    sql_query = "SELECT * FROM #{table_name} WHERE "
    parameters = []

    options = model_attributes_to_db_attributes(options)

    options.each_with_index do |(k, v), index|
      sql_query << "#{k} = $#{index + 1}"
      sql_query << ' AND ' if options.size > index + 1
      parameters << v
    end

    { sql_query:, parameters: }
  end

  def self.instantiate_from_db(query_result)
    return unless query_result

    data_hash = query_result.transform_keys { |k| k.split('_')[1..-1].join('_').to_sym }
    new(**data_hash)
  end
end
