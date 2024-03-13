require_relative 'lib/helpers/csv_handler'
require 'csv'

rows = CSV.read('./data.csv', col_sep: ';')

CSVHandler.import(rows)
