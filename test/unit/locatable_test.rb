require 'test_helper'

class LocatableTest < ActiveSupport::TestCase

  fixtures :incidents

  def test_in_zip
    crimes = Crime.in_zip('53212')
    assert_equal 3, crimes.size
    assert_not_nil crimes[0]
    crimes.each { |i| assert_equal '53212', i.address.zip }
  end
  
  def test_in_zip_none_found
    crimes = Crime.in_zip('45678')
    assert_equal 0, crimes.size
  end
  
  def test_on_street
    crimes = Crime.on_street('N Richards St', '53212')
    assert_equal 1, crimes.size
    assert_not_nil crimes[0]
    
    crimes.each { |i| 
      assert_equal '53212', i.address.zip 
      assert_equal 'N Richards St', i.address.street_name
    }    
  end
  
  def test_on_street_none_by_zip
    crimes = Crime.on_street('N Richards St', '12345')
    assert_equal 0, crimes.size
  end
  
  def test_on_street_none_by_street
    crimes = Crime.on_street('N Foo St', '53212')
    assert_equal 0, crimes.size
  end
  
  def test_between_addresses
    crimes = Crime.between_addresses(2345, 2345, 'N Richards St', '53212')
    assert_equal 1, crimes.size
    
    crimes = Crime.between_addresses(2344, 2345, 'N Richards St', '53212')
    assert_equal 1, crimes.size
    
    crimes = Crime.between_addresses(2345, 2346, 'N Richards St', '53212')
    assert_equal 1, crimes.size
    
    crimes = Crime.between_addresses(0, 3000, 'N Richards St', '53212')
    assert_equal 1, crimes.size
  end
  
  def test_between_addresses_none_found
    crimes = Crime.between_addresses(2344, 2344, 'N Richards St', '53212')
    assert_equal 0, crimes.size
    
    crimes = Crime.between_addresses(0, 0, 'N Richards St', '53212')
    assert_equal 0, crimes.size
  end
end