require 'test_helper'

class Employee::OperationTest < ActiveSupport::TestCase

  should 'create employee' do
    assert_no_difference 'Employee.count' do
      result = Employee::Create.(
        name: '',
        email: 'sklafdj',
        vacation_days: nil,
      )
      assert result.failure?
      assert_equal({
        name: ['must be filled', 'size cannot be less than 3'],
        email: ['is in invalid format'],
        password: ['must be filled', 'size cannot be less than 10'],
        vacation_days: ['must be filled', 'must be Integer']
        }, result['contract.default'].errors.messages
      )
    end

    assert_difference 'Employee.count' do
      result = Employee::Create.(employee_attributes)
      assert result.success?, result['contract.default'].errors.messages
    end

    employee = Employee.last
    assert_equal 'Max Muster', employee.name
    assert_equal 'mail@muster.de', employee.email
    assert_equal 30, employee.vacation_days
    assert_nil employee.taken_vacation_days
  end

end
