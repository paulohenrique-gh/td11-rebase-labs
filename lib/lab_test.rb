require 'base_model'

class LabTest < BaseModel
  attr_accessor :id, :patient_id, :doctor_id, :results_token, :date, :type, :type_limits, :type_results

  def initialize(id: nil, patient_id:, doctor_id:, results_token:, date:,
                 type:, type_limits:, type_results: nil)
    @id = id
    @patient_id = patient_id
    @doctor_id = doctor_id
    @results_token = results_token
    @date = date
    @type = type
    @type_limits = type_limits
    @type_results = type_results
  end

  private

  def self.entity_name
    'test'
  end

  def self.table_name
    'lab_tests'
  end
end
