require 'database/database_connection'

class Patient
  attr_accessor :id, :cpf, :name, :email, :birth_date, :address, :city, :state

  def initialize(id: nil, cpf:, name:, email:, birth_date:, address:, city:, state:)
    @id = id
    @cpf = cpf
    @name = name
    @email = email
    @birth_date = birth_date
    @address = address
    @city = city
    @state = state
  end

  def self.create(cpf:, name:, email:, birth_date:, address:, city:, state:)
    sql_string = "
      INSERT INTO patients (patient_cpf, patient_name, patient_email, patient_birthdate,
        patient_address, patient_city, patient_state)
      VALUES ($1, $2, $3, $4, $5, $6, $7);
    "
    conn = DatabaseConnection.connect
    conn.exec_params(sql_string, [cpf, name, email, birth_date, address, city, state])

    conn.close if conn
  end

  def self.count
    conn = DatabaseConnection.connect
    count = conn.exec('SELECT COUNT (*) FROM patients;').entries.size
    conn.close if conn

    count
  end

  def self.all
    conn = DatabaseConnection.connect
    patients = conn.exec('SELECT * FROM patients;').entries
    conn.close if conn

    patients.map do |patient|
      new(id: patient['patient_id'], cpf: patient['patient_cpf'],
          name: patient['patient_name'], email: patient['patient_email'],
          birth_date: patient['patient_birthdate'], address: patient['patient_address'],
          city: patient['patient_city'], state: patient['patient_state'])
    end
  end
end
