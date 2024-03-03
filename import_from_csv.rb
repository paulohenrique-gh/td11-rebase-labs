require 'csv'
require 'pg'

conn = PG.connect(
  dbname: 'postgres',
  user: 'postgres',
  password: 'password',
  host: 'db',
  port: 5432
)

conn.exec('CREATE TABLE IF NOT EXISTS exames (
  id SERIAL,
  cpf VARCHAR,
  nome_paciente VARCHAR,
  email_paciente VARCHAR,
  data_nascimento_paciente DATE,
  endereco_rua_paciente VARCHAR,
  cidade_paciente VARCHAR,
  estado_paciente VARCHAR,
  crm_medico VARCHAR,
  crm_medico_estado VARCHAR,
  nome_medico VARCHAR,
  email_medico VARCHAR,
  token_resultado_exame VARCHAR,
  data_exame DATE,
  tipo_exame VARCHAR,
  limites_tipo_exame VARCHAR,
  resultado_tipo_exame VARCHAR
);')

rows = CSV.read('./data.csv', col_sep: ';')
rows.shift

sql_string = "
  INSERT INTO exames (
    cpf, nome_paciente, email_paciente, data_nascimento_paciente,
    endereco_rua_paciente, cidade_paciente, estado_paciente, crm_medico,
    crm_medico_estado, nome_medico, email_medico, token_resultado_exame,
    data_exame, tipo_exame, limites_tipo_exame, resultado_tipo_exame
  )
  VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
"
puts 'Importando dados...'

rows.each do |row|
  conn.exec_params(sql_string, row)
end

conn.close if conn

puts 'Dados importados com sucesso'
