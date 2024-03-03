require 'csv'
require 'pg'

db_name = if ENV['RACK_ENV'] == 'test'
            'test'
          else
            'development'
          end

conn = PG.connect(
  dbname: db_name,
  user: 'postgres',
  password: 'password',
  host: 'db',
  port: 5432
)

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
