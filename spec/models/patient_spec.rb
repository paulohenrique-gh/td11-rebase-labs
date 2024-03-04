require 'patient'

RSpec.describe Patient do
  it 'returns the correct attribute values' do
    patient = Patient.new(
      cpf: '048.445.170-88',
      name: 'Renato Barbosa',
      email: 'renato.barbosa@ebert-quigley.com',
      birth_date: '1999-03-19',
      address: '192 Rua Pedras',
      city: 'Ituverava',
      state: 'Alagoas'
    )

    expect(patient.cpf).to eq '048.445.170-88'
    expect(patient.name).to eq 'Renato Barbosa'
    expect(patient.email).to eq 'renato.barbosa@ebert-quigley.com'
    expect(patient.birth_date).to eq '1999-03-19'
    expect(patient.address).to eq '192 Rua Pedras'
    expect(patient.city).to eq 'Ituverava'
    expect(patient.state).to eq 'Alagoas'
  end
end
