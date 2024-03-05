require 'base_model'

class Doctor < BaseModel
  attr_accessor :id, :crm, :crm_state, :name, :email

  def initialize(id: nil, crm:, crm_state:, name:, email:)
    @id = id
    @crm = crm
    @crm_state = crm_state
    @name = name
    @email = email
  end
end
