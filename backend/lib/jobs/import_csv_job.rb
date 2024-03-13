require 'sidekiq'

class ImportCsvJob
  include Sidekiq::Job

  def perform
    sleep 5
    puts 'Job done'
  end
end
