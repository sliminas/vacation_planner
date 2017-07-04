require 'holidays'
require 'holidays/core_extensions/date'

class Date

  include Holidays::CoreExtensions::Date

  def workday?
    !(saturday? || sunday? || holiday?(:de_sl))
  end

end

Holidays.cache_between(
  Date.new(Time.current.year, 1, 1),
  Date.new(Time.current.year, 12, 31),
  :de,
  :de_sl,
  :observed
)
