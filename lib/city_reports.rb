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
    if report.address 
      report = @geo_lookup.lookup(report) if ! report.address.geo_location
      report.geo_location = report.address.geo_location if report.address.geo_location
    end
    report
  end
  
end
