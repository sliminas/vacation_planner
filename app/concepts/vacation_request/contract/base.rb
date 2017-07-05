class VacationRequest::Contract::Base < Reform::Form

  model :vacation_request

  property :start_date
  property :end_date
  property :state, parse: false, default: 'pending'
  property :employee

  validates :start_date, :end_date, :state, :employee, presence: true

  def start_date
    Date.parse(super) if super.present?
  rescue ArgumentError
    nil
  end

  def end_date
    Date.parse(super) if super.present?
  rescue ArgumentError
    nil
  end

  def vacation_days
    date_range.workdays.count
  end

  def total_days
    date_range.days.count
  end

  private

  def date_range
    @duration ||= DateRange.new(start_date, end_date) if start_date && end_date
  end

end
