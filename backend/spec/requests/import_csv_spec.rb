require 'spec_helper'

describe "POST '/import'" do
  it 'imports data from CSV file to database successfully' do
    fake_csv = 'spec/support/test.csv'

    post '/import', file: Rack::Test::UploadedFile.new(fake_csv, 'text/csv')

    expect(Patient.all.count).to eq 1
    expect(Doctor.all.count).to eq 1
    expect(LabExam.all.count).to eq 1
    expect(Test.all.count).to eq 4
    expect(last_response.status).to eq 200
    expect(last_response.content_type).to include 'application/json'
  end

  it 'returns an error if file type is not supported' do
    txt_file = 'spec/support/test.txt'

    post '/import', file: Rack::Test::UploadedFile.new(txt_file, 'text/plain')

    expect(last_response.status).to eq 422
    json_response = JSON.parse(last_response.body, symbolize_names: true)
    expect(json_response[:error]).to eq 'File type is not CSV.'
  end
end