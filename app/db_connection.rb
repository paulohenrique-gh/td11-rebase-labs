require 'pg'

conn = PG.connect(
  dbname: 'postgres',
  user: 'postgres',
  password: 'password',
  host: 'db',
  port: 5432
)

user = conn.exec('SELECT * FROM users')
puts user.entries
