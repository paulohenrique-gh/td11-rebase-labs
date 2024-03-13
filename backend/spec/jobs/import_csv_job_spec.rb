require 'spec_helper'
require_relative '../../lib/jobs/import_csv_job'

RSpec.describe ImportCsvJob do
  it '#perform' do
    file = 'spec/support/test.csv'

    copy_file_path = "/app/tmp/#{File.basename(file)}"

    ImportCsvJob.perform_sync(FileUtils.cp(file, copy_file_path))

    expect(Patient.all.count).to eq 1
    expect(Doctor.all.count).to eq 1
    expect(LabExam.all.count).to eq 1
    expect(Test.all.count).to eq 4
  end
end
