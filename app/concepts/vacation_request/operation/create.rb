class VacationRequest::Create < Trailblazer::Operation

  class Flash
    def self.call(result)
      if result.success?
        { notice: I18n.t('vacation_request.create.success')}
      else
        if (errors = result['contract.default'].errors&.messages).present?
          if errors[:vacation_days]
            [:error, errors[:vacation_days].first]
          end
        else
          [:error, I18n.t('vacation_request.create.failure')]
        end
      end
    end
  end

  class Present < Trailblazer::Operation

    step Model(VacationRequest, :new)
    step Contract::Build(constant: VacationRequest::Contract::Create)

  end

  step Nested(Present)
  step ->(options, employee:, params:, **) {
    options['params'][:vacation_request] = params[:vacation_request].merge(employee: employee)
  }
  step Contract::Validate(key: :vacation_request)
  step Contract::Persist()


end
