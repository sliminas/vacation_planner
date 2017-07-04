class VacationRequest::Present < Trailblazer::Operation

  step Model(VacationRequest, :find_by)

end
