require 'spec_helper'
require 'csv'
require_relative '../../lib/jobs/import_csv_job'

RSpec.describe ImportCsvJob do
  it '#perform' do
    file = 'spec/support/test.csv'

    rows = CSV.read(file, col_sep: ';')

    ImportCsvJob.perform_sync(rows)

    expect(Patient.all.count).to eq 1
    expect(Doctor.all.count).to eq 1
    expect(LabExam.all.count).to eq 1
    expect(Test.all.count).to eq 4
  end
end
