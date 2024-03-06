require_relative 'base_model'

class Test < BaseModel
  attr_accessor :id, :lab_exam_id, :type, :type_limits, :type_results

  def initialize(id: nil, lab_exam_id:, type:, type_limits:, type_results:)
    @id = id
    @lab_exam_id = lab_exam_id
    @type = type
    @type_limits = type_limits
    @type_results = type_results
  end
end
