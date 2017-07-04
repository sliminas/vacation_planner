require_dependency Rails.root.join('app/concepts/employee/operation/present')

class Employee::Destroy < Trailblazer::Operation

  class Flash

    def self.call(result)
      if result.success?
        {
          notice: I18n.t('employee.destroy.success')
        }
      elsif result['last_supervisor']
        {
          alert: I18n.t('employee.destroy.last_supervisor')
        }
      else
        {
          error: I18n.t('employee.destroy.failure')
        }
      end
    end

  end

  step Nested(::Employee::Present)
  step ->(options, model:, **) {
    if !model.supervisor? || Employee.supervisors.count > 1
      true
    else
      options['last_supervisor'] = true
      false
    end
  }
  step ->(*, model:, **) {
    model.destroy
  }

end
