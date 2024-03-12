require 'spec_helper'

describe '/import' do
  it 'sends file to the backend successfully' do
    test_csv = 'spec/support/test.csv'
    fake_response = double('Faraday::Response',
                           status: 200,
                           success?: true,
                           body: { message: 'Data imported successfully.' }.to_json)
    allow(Faraday).to receive(:get).and_return(fake_response)

    post '/import', file: Rack::Test::UploadedFile.new(test_csv, 'text/csv')

    expect(last_response.status).to eq 200
    json_response = JSON.parse(last_response.body)
    expect(json_response['message']).to eq 'Data imported successfully.'
  end

  it 'returns error when file format is invalid' do
    test_file = 'spec/support/test.txt'

    post '/import', file: Rack::Test::UploadedFile.new(test_file, 'text/plain')

    expect(last_response.status).to eq 422
    json_response = JSON.parse(last_response.body)
    expect(json_response['error']).to eq 'File type not supported.'
  end

  it 'returns error when no file is sent' do
    post '/import'

    expect(last_response.status).to eq 400
  end
end
