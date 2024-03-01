require 'spec_helper'

describe "GET '/'" do
  it 'returns hello' do
    get '/'
    expect(last_response.body).to eq 'Hello World'
  end
end
