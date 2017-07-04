class DateRange

  attr_reader :start_date, :end_date

  def initialize(start_date, end_date)
    start_date = Date.parse(start_date) if start_date.is_a?(String)
    end_date = Date.parse(end_date) if end_date.is_a?(String)

    start_date, end_date = end_date, start_date if start_date > end_date
    @start_date, @end_date = start_date, end_date
  end

  def includes_date?(date)
    return false unless date.present?
    start_date <= date && date <= end_date
  end

  def includes_date_range?(date_range)
    return false unless date_range.present?
    start_date <= date_range.start_date && date_range.end_date <= end_date
  end

  def overlaps_date_range?(date_range)
    date_range.present? &&
      !includes_date_range?(date_range) &&
      (includes_date?(date_range.start_date) ||
        includes_date?(date_range.end_date))
  end

  def conflict?(date_range)
    date_range.present? &&
      (includes_date_range?(date_range) || overlaps_date_range?(date_range))
  end

  def day_count
    days.count
  end

  def workdays
    days.select { |date| date.workday? }
  end

  def days
    start_date..end_date
  end

  def self.current_year
    year = Time.current.year
    new(Date.new(year, 1, 1), Date.new(year, 12, 31))
  end

end
