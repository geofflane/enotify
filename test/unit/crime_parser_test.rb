class CrimeParserTest < ActiveSupport::TestCase

  def test_crime_parsed_into_good_values
    cp = CrimeParser.new
    crime = cp.parse(CRIME_TEST1, 'Milwaukee', 'WI')
    assert_equal 'Milwaukee', crime.address.city
    assert_equal 'WI', crime.address.state
    assert_equal '310 E BROWN ST', crime.address.street
    assert_equal '#081020141', crime.record_number
    assert_equal 'Burglary', crime.description
    assert_equal 'Filed (Other)', crime.resolution
  end

end
