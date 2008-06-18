require 'test_helper'

class CrimeTest < ActiveSupport::TestCase

  def test_limit_by_time_and_location
    crimes = Crime.in_month(5, 2008).on_street("N Pierce St", 53212)
    assert_equal 1, crimes.size
  end
  
  def test_limit_by_time_and_location_not_found
    crimes = Crime.in_month(5, 2007).on_street("N Pierce St", 53212)
    assert_equal 0, crimes.size
  end
end
