require 'base_model'

class Patient < BaseModel
  attr_accessor :id, :cpf, :name, :email, :birthdate, :address, :city, :state

  def initialize(id: nil, cpf:, name:, email:, birthdate:, address:, city:, state:)
    @id = id
    @cpf = cpf
    @name = name
    @email = email
    @birthdate = birthdate
    @address = address
    @city = city
    @state = state
  end
end
