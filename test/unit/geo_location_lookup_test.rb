class GeoLocationLookupTest < Test::Unit::TestCase
  def test_geo_lookup_finds_address
    incident = Incident.new
    incident.address = Address.new(:street => '2924 N Pierce St', :city => 'Milwaukee', :state => 'WI')

    geo_lookup = GeoLocationLookup.new
    incident = geo_lookup.lookup(incident)

    assert_equal '53212-2550', incident.address.full_zip
    assert_equal '53212', incident.address.zip
    assert_not_nil incident.geo_location.longitude
    assert_not_nil incident.geo_location.latitude
  end
end
