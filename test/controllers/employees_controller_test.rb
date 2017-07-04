require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest

  should 'require supervisor' do
    employee = create_employee
    sign_in employee

    visit '/employees'
    assert_equal '/vacation_requests', current_path
  end

end
