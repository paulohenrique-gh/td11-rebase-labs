require 'sidekiq'
require_relative '../helpers/csv_handler'

class ImportCsvJob
  include Sidekiq::Job

  def perform(rows)
    CSVHandler.import(rows)
  end
end
