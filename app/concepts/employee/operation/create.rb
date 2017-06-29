class Employee::Create < Trailblazer::Operation

  class Present < Trailblazer::Operation

    step Model(Employee, :new)
    step Contract::Build(constant: Employee::Contract::Create)

  end

  step Nested(Present)
  step Contract::Validate()
  step Contract::Persist()

end
