class GeoLocationLookupTest < ActiveSupport::TestCase
  def test_geo_lookup_finds_address
    incident = Incident.new
    incident.address = Address.new('2924 N Pierce St', 'Milwaukee', 'WI')

    geo_lookup = GeoLocationLookup.new
    incident = geo_lookup.lookup(incident)

    assert_equal '53212-2550', incident.address.zip
    assert_not_nil incident.geo_location.long
    assert_not_nil incident.geo_location.lat
  end
end