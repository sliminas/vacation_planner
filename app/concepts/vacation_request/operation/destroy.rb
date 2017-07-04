require_dependency Rails.root.join('app/concepts/vacation_request/operation/present')

class VacationRequest::Destroy < Trailblazer::Operation

  class Flash

    def self.call(result)
      if result.success?
        {
          notice: I18n.t('vacation_request.destroy.success')
        }
      else
        {
          error: I18n.t('vacation_request.destroy.failure')
        }
      end
    end

  end

  step Nested(VacationRequest::Present)
  step ->(options, employee:, model:, **) {
    if model.employee == employee
      true
    else
      options['employee.error'] = :access_denied
      false
    end
  }
  step ->(*, model:, **) {
    model.destroy
  }

end
