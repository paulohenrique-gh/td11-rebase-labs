require 'sidekiq'
require_relative '../helpers/csv_handler'

class ImportCsvJob
  include Sidekiq::Job

  def perform(file_path)
    CSVHandler.import(file_path)

    FileUtils.rm(file_path)
    puts 'Arquivo removido'
  end
end
