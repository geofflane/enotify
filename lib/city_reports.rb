class CityReports
  attr_accessor :parser, :city, :state

  def initialize(parser, geo_lookup, city, state)
    @parser = parser
    @geo_lookup = geo_lookup
    @city = city
    @state = state
  end

  def build_report(text)
    report = @parser.parse(text, @city, @state)
    report = @geo_lookup.lookup(report) if report.address
    report
  end
  
end
