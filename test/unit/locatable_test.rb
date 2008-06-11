require 'test_helper'

class LocatableTest < ActiveSupport::TestCase

  fixtures :incidents

  def test_find_by_zip
    incidents = Incident.find_by_zip('53212')
    assert_equal 3, incidents.size
    assert_not_nil incidents[0]
    incidents.each { |i| assert_equal '53212', i.address.zip }
  end
  
  def test_find_by_zip_none_found
    incidents = Incident.find_by_zip('45678')
    assert_equal 0, incidents.size
  end
  
  def test_find_by_street
    incidents = Incident.find_by_street('N Richards St', '53212')
    assert_equal 1, incidents.size
    assert_not_nil incidents[0]
    
    incidents.each { |i| 
      assert_equal '53212', i.address.zip 
      assert_equal 'N Richards St', i.address.street_name
    }    
  end
  
  def test_find_by_street_none_by_zip
    incidents = Incident.find_by_street('N Richards St', '12345')
    assert_equal 0, incidents.size
  end
  
  def test_find_by_street_none_by_street
    incidents = Incident.find_by_street('N Foo St', '53212')
    assert_equal 0, incidents.size
  end
  
  def test_find_by_address
    incidents = Incident.find_by_address(2345, 2345, 'N Richards St', '53212')
    assert_equal 1, incidents.size
    
    incidents = Incident.find_by_address(2344, 2345, 'N Richards St', '53212')
    assert_equal 1, incidents.size
    
    incidents = Incident.find_by_address(2345, 2346, 'N Richards St', '53212')
    assert_equal 1, incidents.size
    
    incidents = Incident.find_by_address(0, 3000, 'N Richards St', '53212')
    assert_equal 1, incidents.size
  end
  
  def test_find_by_address_none_found
    incidents = Incident.find_by_address(2344, 2344, 'N Richards St', '53212')
    assert_equal 0, incidents.size
    
    incidents = Incident.find_by_address(0, 0, 'N Richards St', '53212')
    assert_equal 0, incidents.size
  end
end