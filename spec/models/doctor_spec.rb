require 'spec_helper'
require 'doctor'

RSpec.describe Doctor do
  it 'returns the correct attribute values' do
    doctor = Doctor.new(
      crm: 'B000BJ20J4',
      crm_state: 'PI',
      name: 'Maria Luiza Pires',
      email: 'maria.pirez@wisozk.biz'
    )

    expect(doctor.crm).to eq 'B000BJ20J4'
    expect(doctor.crm_state).to eq 'PI'
    expect(doctor.name).to eq 'Maria Luiza Pires'
    expect(doctor.email).to eq 'maria.pirez@wisozk.biz'
  end
end
