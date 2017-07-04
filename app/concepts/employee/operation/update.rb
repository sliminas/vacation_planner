class Employee::Update < Trailblazer::Operation

  class Present < ::Employee::Present

    step Contract::Build(constant: Employee::Contract::Update), override: true

  end

  step Nested(Present)
  step Contract::Validate(key: :employee)
  step Contract::Persist()

end
