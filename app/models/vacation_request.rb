class VacationRequest < ApplicationRecord

  belongs_to :employee

  scope :conflicts, ->(date_range) {
    # overlaps uses open interval start <= time < end, so we need +/- 1
    where('(start_date, end_date) OVERLAPS (?::Date, ?::Date)', date_range.start_date - 1, date_range.end_date + 1)
  }

  scope :pending, -> { where(state: 'pending') }

  include Sortable

  def date_range
    DateRange.new(start_date, end_date) if start_date && end_date
  end

end
