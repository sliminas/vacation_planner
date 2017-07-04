class VacationRequest::Manage < Trailblazer::Operation

  class Flash

    def self.call(result)
      if result.success?
        { notice: I18n.t("vacation_request.manage.success.#{result['params']['manage_action']}") }
      else
        message = I18n.t("vacation_request.manage.failure.#{result['params']['manage_action']}")
        reason = ' ' + result['contract.default'].errors&.messages.try(:[], :vacation_days)&.first.to_s
        message += reason if reason.present?
        { alert: message }
      end
    end

  end

  step ->(*, employee:, **) {
    employee.supervisor?
  }
  step Nested(VacationRequest::Present)
  step Contract::Build(constant: VacationRequest::Contract::Manage)
  step Contract::Validate()
  step Contract::Persist()


end
