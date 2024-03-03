require 'pg'

conn = PG.connect(
  dbname: 'postgres',
  user: 'postgres',
  password: 'password',
  host: 'db',
  port: 5432
)

conn.exec("
  CREATE TABLE IF NOT EXISTS users (
    id INT,
    name VARCHAR
  );
")

conn.exec_params("
  INSERT INTO users (id, name) VALUES (5, 'Paulo Henrique');
")

user = conn.exec('SELECT * FROM users')
puts user.entries
