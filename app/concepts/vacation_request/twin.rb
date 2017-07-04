class VacationRequest::Twin < Disposable::Twin

  property :start_date
  property :end_date
  property :vacation_days
  property :total_days
  property :state
  property :employee

  def start_date
    date_format(super)
  end

  def end_date
    date_format(super)
  end

  def date_format(date)
    date.strftime('%a, %d/%m/%Y')
  end

  def employee
    super.name
  end

end
