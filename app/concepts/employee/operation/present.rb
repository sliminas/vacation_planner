class Employee::Present < Trailblazer::Operation

  step Model(Employee, :find_by)
  step Contract::Build(constant: Employee::Contract::Create)

end
