require 'test_helper'

class TemporalTest < ActiveSupport::TestCase
  
  fixtures :incidents
    
  def test_find_by_date
    incidents = Incident.find_by_month_and_year(4, 2008)
    assert_equal 2, incidents.size
    incidents.each { |i| 
      assert_equal 4, i.time.month
      assert_equal 2008, i.time.year
    }
  end
  
  def test_find_by_date
    incidents = Incident.find_by_month_and_year(5, 2008)
    assert_equal 1, incidents.size
    assert_equal 5, incidents[0].time.month
    assert_equal 2008, incidents[0].time.year
  end
  
end