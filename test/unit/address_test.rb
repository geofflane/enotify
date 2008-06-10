require 'test_helper'

class AddressTest < ActiveSupport::TestCase

  def test_setting_full_zip_sets_zip
    a = Address.new(:full_zip => '53212-2345')
    assert_equal '53212-2345', a.full_zip
    assert_equal '53212', a.zip
  end
  
  def test_setting_street_sets_parts
    a = Address.new(:street => '2924 N PIERCE ST')
    assert_equal '2924 N PIERCE ST', a.street
    assert_equal 2924, a.street_number
    assert_equal 'N PIERCE ST', a.street_name
  end
end
