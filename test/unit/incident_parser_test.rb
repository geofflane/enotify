class IncidentParserTest < ActiveSupport::TestCase

  def test_incident_parsed_into_good_values
    ip = IncidentParser.new
    incident = ip.parse(INCIDENT_TEST1, 'Milwaukee', 'WI')
    assert_equal 'Milwaukee', incident.address.city
    assert_equal 'WI', incident.address.state
    assert_equal '310 E BROWN ST', incident.address.street1
    assert_equal '#081020141', incident.report_number
    assert_equal 'Burglary', incident.description
    assert_equal 'Filed (Other)', incident.resolution
  end

end
