require 'test_helper'
require 'concepts/vacation_request/test_helper'

class VacationRequestTest < ActiveSupport::TestCase

  include VacationRequestTestHelper

  should 'find conflicts' do
    employee = create_employee
    request = create_vacation_request(employee: employee, start_date: '01/01/2017', end_date: '05/01/2017')

    assert_equal [request], VacationRequest.conflicts(DateRange.new('05/01/2017', '06/01/2017'))
    assert_equal [request], VacationRequest.conflicts(DateRange.new('03/01/2017', '04/01/2017'))
    assert_equal [request], VacationRequest.conflicts(DateRange.new('03/01/2017', '10/01/2017'))
    assert_equal [request], VacationRequest.conflicts(DateRange.new('30/12/2016', '01/01/2017'))

    assert_equal [], VacationRequest.conflicts(DateRange.new('30/12/2016', '31/12/2016'))
    assert_equal [], VacationRequest.conflicts(DateRange.new('06/01/2017', '07/01/2017'))
  end

end
