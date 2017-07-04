module VacationRequest::Contract

  class Manage < Base

    property :start_date, parse: false, writable: false
    property :end_date, parse: false, writable: false
    property :manage_action, virtual: true
    property :state, parse: false
    property :employee, parse: false

    validates :manage_action, presence: true, inclusion: { in: %w(accepted declined) }
    validates :state, presence: true, inclusion: { in: %w(pending) }
    validate do
      errors.add(:vacation_days, :too_few) if manage_action == 'accepted' &&
        new_taken_vacation_days > employee.vacation_days
    end

    def save
      employee.update(taken_vacation_days: new_taken_vacation_days) if 'accepted' == manage_action
      self.state = manage_action
      super
    end

    private

    def new_taken_vacation_days
      employee.taken_vacation_days + vacation_days
    end

  end

end
