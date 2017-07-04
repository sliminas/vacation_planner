require 'test_helper'

class Employee::OperationTest < ActiveSupport::TestCase

  should 'create employee' do
    assert_no_difference 'Employee.count' do
      result = Employee::Create.(employee: {
          name: '',
          email: 'sklafdj',
          vacation_days: nil,
        }
      )
      assert result.failure?
      assert_equal({
        name: ['is too short (minimum is 3 characters)', "can't be blank"],
        email: ['is invalid'],
        vacation_days: ['is not a number', "can't be blank"],
        password: ["can't be blank"]
        }, result['contract.default'].errors.messages
      )
    end

    assert_difference 'Employee.count' do
      result = Employee::Create.(employee: employee_attributes(attributes: {
        name: 'Max Muster',
        email: 'mail@muster.de'
      }))
      assert result.success?, result['contract.default'].errors.messages
    end

    employee = Employee.last
    assert_equal 'Max Muster', employee.name
    assert_equal 'mail@muster.de', employee.email
    assert_equal 30, employee.vacation_days
    assert !employee.supervisor?
  end

  context 'with existing employee' do
    setup do
      @employee = create_employee
    end

    should 'update employee' do
      encrypted_pw = @employee.encrypted_password
      assert encrypted_pw.present?
      result = Employee::Update.(id: @employee.to_param, employee: {
        name: 'Fooo',
        email: '',
        password: '',
        vacation_days: -1,
        supervisor: true
      })
      assert result.failure?
      assert_equal(
        {
          email: ['is invalid', "can't be blank"],
          vacation_days: ['must be greater than or equal to 0']
        },
        result['contract.default'].errors.messages
      )

      result = Employee::Update.(id: @employee.to_param, employee: {
        name: 'Fooo',
        email: 'bla@blub.de',
        password: '',
        vacation_days: 76.3,
        supervisor: true
      })
      assert result.success?, result['contract.default'].errors.messages

      assert_equal 'Fooo', @employee.reload.name
      assert_equal 'bla@blub.de', @employee.email
      # should only be updated if new one is present
      assert_equal encrypted_pw, @employee.encrypted_password
      assert_equal 76.3, @employee.vacation_days
      assert @employee.supervisor
    end

    should 'not remove last supervisor flag' do
      assert @employee.update supervisor: true
      assert Employee.last_supervisor?

      result = Employee::Update.(id: @employee.to_param, employee: {
        supervisor: false
      })
      assert result.failure?
      assert_equal ['Can not remove supervisor flag since this is the last supervisor.'],
        result['contract.default'].errors.messages[:supervisor]
    end

    should 'destroy employee' do
      assert_difference 'Employee.count', -1 do
        result = Employee::Destroy.(id: @employee.to_param)
        assert result.success?, Employee::Destroy::Flash.(result)
        assert_equal(
          { notice: 'Employee successfully deleted.' },
          Employee::Destroy::Flash.(result)
        )
      end
    end

    should 'not destroy last supervisor' do
      assert @employee.update supervisor: true
      assert_no_difference 'Employee.count' do
        result = Employee::Destroy.(id: @employee.to_param)
        assert result.failure?, Employee::Destroy::Flash.(result)
        assert_equal(
          { alert: 'The employee can not be deleted because it is the last supervisor.' },
          Employee::Destroy::Flash.(result)
        )
      end

    end
  end

end
