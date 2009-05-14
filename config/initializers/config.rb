
class Date
  def beginning_and_end_of_month
    [beginning_of_month.yesterday.end_of_day, end_of_month.end_of_day]
  end
end

Time::DATE_FORMATS[:simple] = "%m/%d/%Y %I:%M%p"
Time::DATE_FORMATS[:ical] = "%Y%m%dT%H%M%S"
