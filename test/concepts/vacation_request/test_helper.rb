require_relative '../employee/test_helper'

module VacationRequestTestHelper

  include EmployeeTestHelper

  def create_vacation_request(**args)
    result = VacationRequest::Create.(
      { vacation_request: vacation_request_attributes(args.except(:employee)) },
      employee: args[:employee] || create_employee
    )
    result.success? ? result['contract.default'].model : raise(result['contract.default'].errors.messages.to_s)
  end

  def vacation_request_attributes(**args)
    {
      start_date: Date.today.to_s,
      end_date: Date.tomorrow.to_s,
    }.merge(args)
  end

end
