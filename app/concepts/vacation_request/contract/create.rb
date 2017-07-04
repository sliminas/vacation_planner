module VacationRequest::Contract

  class Create < Base

    validate do
      errors.add(:start_date, :wrong_year) if start_date.present? &&
        !DateRange.current_year.includes_date?(start_date)

      if end_date.present?
        errors.add(:end_date, :before_start) if start_date > end_date
        errors.add(:end_date, :wrong_year) unless DateRange.current_year.includes_date?(end_date)
      end

      if date_range
        errors.add(:vacation_days, :too_few) if employee.remaining_vacation_days < vacation_days
        errors.add(:vacation_days, :none) if vacation_days.zero?
      end

      check_vacation_conflicts if date_range
    end


    def save
      model.vacation_days = vacation_days
      model.total_days = total_days
      super
    end

    private

    def check_vacation_conflicts
      if conflicting_request = employee.vacation_requests.conflicts(date_range).first
        errors.add(:start_date, :conflict) if conflicting_request.date_range.includes_date?(start_date)
        errors.add(:end_date, :conflict) if conflicting_request.date_range.includes_date?(end_date)
      end
    end

  end

end
