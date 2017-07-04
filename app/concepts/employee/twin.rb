class Employee::Twin < Disposable::Twin

  property :name
  property :email
  property :vacation_days
  property :taken_vacation_days
  property :supervisor
  property :vacation_requests_count

  def supervisor
    super ? 'x' : ''
  end

end
