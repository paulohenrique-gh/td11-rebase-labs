require 'spec_helper'
require 'doctor'

RSpec.describe Doctor do
  it 'returns the correct attribute values' do
    doctor = Doctor.new(crm: 'B000BJ20J4', crm_state: 'PI',
                        name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz')

    expect(doctor.crm).to eq 'B000BJ20J4'
    expect(doctor.crm_state).to eq 'PI'
    expect(doctor.name).to eq 'Maria Luiza Pires'
    expect(doctor.email).to eq 'maria.pirez@wisozk.biz'
  end

  context '.create' do
    it 'saves doctor in the database and generates ID' do
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI',
                             name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz')

      expect(doctor.id).not_to be_nil
      expect(doctor.crm).to eq 'B000BJ20J4'
      expect(doctor.crm_state).to eq 'PI'
      expect(doctor.name).to eq 'Maria Luiza Pires'
      expect(doctor.email).to eq 'maria.pirez@wisozk.biz'
    end

    it 'does not save two doctors with the same crm' do
      Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI',
                    name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz')
      Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI',
                    name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz')

      conn = DatabaseConnection.connect
      doctors_count = conn.exec('SELECT COUNT (*) FROM doctors;').getvalue(0, 0).to_i
      conn.close if conn

      expect(doctors_count).to eq 1
    end
  end

  context '.find_by' do
    it 'returns the doctor according to given parameter' do
      Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI',
                    name: 'Maria Luiza Pires', email: 'maria.pirez@wisozk.biz')

      doctor = Doctor.find_by(crm: 'B000BJ20J4')

      expect(doctor.name).to eq 'Maria Luiza Pires'
    end
  end
end
