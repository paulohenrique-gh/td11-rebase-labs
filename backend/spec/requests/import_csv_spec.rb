require 'spec_helper'

describe "POST '/import'" do
  it 'success when file type is supported' do
    fake_csv = 'spec/support/test.csv'

    post '/import', file: Rack::Test::UploadedFile.new(fake_csv, 'text/csv')

    expect(last_response.content_type).to include 'application/json'
    json_response = JSON.parse(last_response.body, symbolize_names: true)
    expect(json_response[:message]).to eq 'Processing file.'
  end

  it 'returns an error if file type is not supported' do
    txt_file = 'spec/support/test.txt'

    post '/import', file: Rack::Test::UploadedFile.new(txt_file, 'text/plain')

    expect(last_response.status).to eq 422
    json_response = JSON.parse(last_response.body, symbolize_names: true)
    expect(json_response[:error]).to eq 'File type is not CSV.'
  end

  it 'returns error when there is no file'
end
