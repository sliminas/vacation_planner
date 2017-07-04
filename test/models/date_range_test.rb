require 'test_helper'

class DateRangeTest < ActiveSupport::TestCase

  should 'calculate days in range' do
    assert_equal 2, DateRange.new(Date.today, Date.tomorrow).day_count
  end

  should 'create range for current year' do
    current_year = DateRange.current_year
    assert_equal Date.new(Time.current.year, 1, 1), current_year.start_date
    assert_equal Date.new(Time.current.year, 12, 31), current_year.end_date
  end

  should 'detect included date range' do
    range = DateRange.new(Date.new(2017, 3, 3), Date.new(2017, 6, 6))
    assert range.includes_date_range?(
      DateRange.new(Date.new(2017, 4, 4), Date.new(2017, 4, 5))
    )

    assert !range.includes_date_range?(
      DateRange.new(Date.new(2016, 1, 1), Date.new(2017, 3, 1))
    )

    current_year = DateRange.current_year
    assert current_year.includes_date?(Date.new(2017, 1, 1))
    assert current_year.includes_date?(Date.new(2017, 12, 31))
    assert !current_year.includes_date?(Date.new(2016, 12, 31))
    assert !current_year.includes_date?(Date.new(2018, 1, 1))
  end

  should 'detect overlapping ranges' do
    year = DateRange.current_year
    assert year.overlaps_date_range?(DateRange.new(
      Date.new(2016, 12, 31),
      Date.new(2017, 1, 1)
    ))
    assert !year.overlaps_date_range?(DateRange.new(
      Date.new(2016, 12, 30),
      Date.new(2016, 12, 31)
    ))
  end

  should 'detect conflicts' do
    year = DateRange.current_year
    assert year.conflict?(DateRange.new(
      Date.new(2017, 2, 2),
      Date.new(2017, 3, 3)
    ))
    assert year.conflict?(DateRange.new(
      Date.new(2016, 12, 31),
      Date.new(2017, 1, 1)
    ))
    assert !year.conflict?(DateRange.new(
      Date.new(2016, 12, 30),
      Date.new(2016, 12, 31)
    ))
  end

end
