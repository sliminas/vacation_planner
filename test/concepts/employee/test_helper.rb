module EmployeeTestHelper

  def create_supervisor(**args)
    create_employee(args.merge(supervisor: true))
  end

  def create_employee(**args)
    result = Employee::Create.(employee_attributes.merge(args))
    result.success? ? result['contract.default'].model : raise(result['contract.default'].errors.messages.to_s)
  end

  def employee_attributes(attributes: {})
    {
      name: 'Max Muster',
      email: 'mail@muster.de',
      password: '#password123',
      vacation_days: 30
    }.merge(attributes)
  end

end
