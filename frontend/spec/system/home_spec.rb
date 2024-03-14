require 'spec_helper'

describe 'Home' do
  it 'has the app name' do
    visit '/'

    expect(page).to have_content 'Rebase Labs'
  end
end
