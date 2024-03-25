require 'spec_helper'
require 'csv'
require_relative '../../lib/jobs/import_csv_job'

RSpec.describe ImportCsvJob do
  it '#perform_sync' do
    file = 'spec/support/test.csv'
    spy_csv_handler = spy('CSVHandler')
    stub_const('CSVHandler', spy_csv_handler) 
    rows = CSV.read(file, col_sep: ';')

    ImportCsvJob.perform_sync(rows)

    expect(CSVHandler).to have_received(:import).with(rows)
  end

  it '#perform_async' do
    file = 'spec/support/test.csv'
    rows = CSV.read(file, col_sep: ';')

    expect{ ImportCsvJob.perform_async(rows) }.to enqueue_sidekiq_job.with(rows)
  end
end
