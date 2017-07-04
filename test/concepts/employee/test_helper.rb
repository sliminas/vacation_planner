module EmployeeTestHelper

  def create_supervisor(**args)
    create_employee(args.merge(supervisor: true))
  end

  def create_employee(**args)
    result = Employee::Create.(employee: employee_attributes.merge(args))
    result.success? ? result['contract.default'].model : raise(result['contract.default'].errors.messages.to_s)
  end

  def employee_attributes(attributes: {})
    {
      name: Faker::Name.name,
      email: Faker::Internet.email,
      password: '#password123',
      vacation_days: 30,
      supervisor: false
    }.merge(attributes)
  end

end
