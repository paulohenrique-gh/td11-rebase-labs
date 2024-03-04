require 'pg'

class DatabaseConnection
  def self.connect
    conn = PG.connect(
      dbname: self.database_name,
      user: 'postgres',
      password: 'password',
      host: 'db',
      port: 5432
    )
  end

  private

  def self.database_name
    return 'test' if ENV['RACK_ENV'] == 'test'
    'development'
  end
end
