require 'csv'
require_relative 'lib/lab_test'

rows = CSV.read('./data.csv', col_sep: ';')
rows.shift

puts 'Importando dados...'

LabTest.import_data_from_csv(rows)

puts 'Dados importados com sucesso'
