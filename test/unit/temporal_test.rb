require 'test_helper'

class TemporalTest < ActiveSupport::TestCase
  
  fixtures :incidents
    
  def test_find_by_date_april
    incidents = Incident.in_month(4, 2008)
    assert_equal 2, incidents.size
    incidents.each { |i| 
      assert_equal 4, i.incident_time.month
      assert_equal 2008, i.incident_time.year
    }
  end
  
  def test_find_by_date_may
    incidents = Incident.in_month(5, 2008)
    assert_equal 1, incidents.size
    assert_equal 5, incidents[0].incident_time.month
    assert_equal 2008, incidents[0].incident_time.year
  end
  
  def test_find_by_date_not_found
    incidents = Incident.in_month(4, 2006)
    assert_equal 0, incidents.size
  end
end