class Patient
  attr_accessor :cpf, :name, :email, :birth_date, :address, :city, :state

  def initialize(cpf:, name:, email:, birth_date:, address:, city:, state:)
    @cpf = cpf
    @name = name
    @email = email
    @birth_date = birth_date
    @address = address
    @city = city
    @state = state
  end
end
