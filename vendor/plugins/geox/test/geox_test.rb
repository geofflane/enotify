require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require 'geox'

class GeoXTest < Test::Unit::TestCase

  # show that geocoders fail correctly on network error
  def test_failure
    geocoder = GeoX::Geocoder.new(:geoengine => GeoX::NetFail)
    location = {:address => '700 19th', :city => 'San Francisco', :state => 'CA'}
    locations = geocoder.geocode(location)
    assert !locations[0].success?

    # show that each engine can return failure on network error as well
    [GeoX::Google, GeoX::Yahoo, GeoX::MapQuest].each do |geoengine_klass|
      # unfortunately we have to use a real site here - opendns provides html results (i.e. http 200) for bad dns records now
      # rubyonrails.org is kind enough to rapidly throw away bad port requests. Big sites generally hold on to the requests
      # for a long time, making this test very slow. If someone has a better suggestion, I'm all ears.
      geocoder = GeoX::Geocoder.new(:geoengine => geoengine_klass, :api_url_base => 'http://www.rubyonrails.org:2903')
      locations = geocoder.geocode(location)
      assert !locations[0].success?, "Expected Network failure but was #{locations.inspect} for #{geoengine_klass}"
    end
  end

  # show that we can failover from one engine to another if we provide multiple engines to the Geocoder
  def test_failover
    location = {:address => '700 19th', :city => 'San Francisco', :state => 'CA'}
    geocoder = GeoX::Geocoder.new(:geoengine => [GeoX::NetFail, GeoX::Google])
    locations = geocoder.geocode(location)
    assert locations[0].success?
    assert_equal 2, locations.size
  end

  def test_google_geocoder
    if GeoX::GOOGLE_API_KEY.blank?
      STDERR::puts "Can't test Google API unless you specify a GOOGLE_API_KEY in geox_api_keys.rb"
      assert true
    else
      location = {:address => '700 19th', :city => 'San Francisco', :state => 'CA'}
      geocoder = GeoX::Geocoder.new(:geoengine => GeoX::Google)
      locations = geocoder.geocode(location)
      assert_equal 2, locations.size
      streets = ["700 19TH AVE", "700 19TH ST"]
      locations.each do |location|
        streets.delete_if {|street| street = location.address}
        assert location.kind_of?(GeoX::Street)
      end
      assert_equal 0, streets.size

      # prove we get back street addresses that are correctly formed
      location = {:address => '1711 Martin Luther King Junior Wy', :city => 'Berkeley', :state => 'CA'}
      locations = geocoder.geocode(location)
      assert_equal 1, locations.size
      assert_equal "1711 Martin Luther King Jr Way", locations[0].address
      assert locations[0].kind_of?(GeoX::Street)
      # show that Google gives good intersection back for a
      # single, unambiguous street intersection
      ['Virginia St and Milvia St', 'Virginia St at Milvia St'].each do |address|
        location = {:address => address, :city => 'Berkeley', :state => 'CA'}
        locations = geocoder.geocode(location)
        assert_equal 1, locations.size
        # show intersection conversion is working
        assert_equal "Virginia St & Milvia St", locations[0].address, "Address provided was: #{address}"
        locations = geocoder.geocode(location)
        assert_equal 1, locations.size
      end
      # test utf8 locale capability - we should test deeper but it's a bit of a pain
      # right now we just make sure that adding locale doesn't break anything
      location = {:address => '1711 Martin Luther King Junior Wy', :city => 'Berkeley', :state => 'CA'}
      oe_utf8 = 'oe=utf8'
      geocoder = GeoX::Geocoder.new(:geoengine => GeoX::Google, :locale => oe_utf8)
      locations = geocoder.geocode(location)
      assert_equal 1, locations.size
    end # if/else GOOGLE_API_KEY.blank?
  end

  # tests to verify functions across multiple engines, if api keys are installed
  # use this test module to prove functions which should have the same behavior
  # across all the installed engines
  def test_cross_engine_functions
    {GeoX::Google => GeoX::GOOGLE_API_KEY, GeoX::MapQuest => GeoX::MAPQUEST_API_KEY, GeoX::Yahoo => GeoX::YAHOO_API_KEY}.each do |engine, api_key|
      if !api_key.blank?
        # prove we can get lat/long from an address
        location = {:address => '10 Pine Flat Rd', :city => 'Santa Cruz', :state => 'CA'}
        geocoder = engine.new
        locations = geocoder.geocode(location)
        assert_equal 1, locations.size
        geocode = locations[0]
        assert geocode == GeoX::Street
        assert_equal '37.042', geocode.latitude[0..5]
        assert_equal '-122.150',  geocode.longitude[0..7]
        assert_equal '95060', geocode.post_code[0..4]

        # prove we can get a PostCode level coding from city/zip or just zip
        city_zip = {:post_code => '95060', :city => 'Santa Cruz', :state => 'CA'}
        zip = {:post_code => '95060'}
        [city_zip, zip].each do |location|
          locations = geocoder.geocode(location)
          assert_equal 1, locations.size
          geocode = locations[0]
          # 3/6/08 - Yahoo is annoyingly returning city level geocodes for postcodes right now
          if engine == GeoX::Yahoo
            assert(geocode <= GeoX::City, "Yahoo: Expected city or better level coding but got #{geocode} for #{engine.to_s} using location #{location.inspect}")
          else
            assert(geocode == GeoX::PostCode, "Expected postcode level coding but got #{geocode} for #{engine.to_s} using location #{location.inspect}")
            assert_equal '95060', geocode.post_code[0..4]
          end
        end

        # prove we can get a City level coding from city/state
        location = {:city => 'Los Angeles', :state => 'CA'}
        locations = geocoder.geocode(location)
        assert_equal 1, locations.size
        geocode = locations[0]
        assert geocode.kind_of?(GeoX::City), "Failed to find city geocode for #{engine} - was found #{geocode}"

      else
        STDERR::puts("Warning: API key not installed for #{engine.inspect}")
        assert true
      end
    end
  end

  def test_yahoo_geocoder
    if GeoX::YAHOO_API_KEY.blank?
      STDERR::puts "Can't test Yahoo API unless you specify a YAHOO_API_KEY in geox_api_keys.rb"
      assert true
    else
      location = {:address => '700 19th', :city => 'San Francisco', :state => 'CA'}
      geocoder = GeoX::Geocoder.new(:geoengine => GeoX::Yahoo)
      locations = geocoder.geocode(location)
      assert_equal 2, locations.size
      assert_match %r{700 19th Ave}i, locations[0].address

      # prove we get back street addresses that are correctly formed
      # Yahoo is conservative - it won't declare that this is an exact match even though it's so close
      # don't blame me - try MapQuest - it works better
      location = {:address => '1711 Martin Luther King Junior Wy', :city => 'Berkeley', :state => 'CA'}
      locations = geocoder.geocode(location)
      assert_equal 1, locations.size
      assert_match %r{1711 MARTIN LUTHER KING JR WAY}i, locations[0].address
      assert locations[0].kind_of?(GeoX::Unknown)

      # Yahoo does handle intersections better than MapQuest though
      # single, unambiguous street intersection return Street geocode
      location = {:address => 'Virginia St @ Milvia St', :city => 'Berkeley', :state => 'CA'}
      locations = geocoder.geocode(location)
      assert_equal 1, locations.size
      assert_match %r{VIRGINIA ST &amp; MILVIA ST}i, locations[0].address

      # Yahoo does handle intersections better than MapQuest though
      # single, unambiguous street intersection
      location = {:address => 'Virginia St at Milvia St', :city => 'Berkeley', :state => 'CA'}
      locations = geocoder.geocode(location)
      assert_equal 1, locations.size
      assert_match %r{VIRGINIA ST &amp; MILVIA ST}i, locations[0].address
    end # if/else YAHOO_API_KEY.blank?
  end

  # These tests could break if MapQuest changes their geocoding system
  def test_mapquest_geocoder
    if GeoX::MAPQUEST_API_KEY.blank?
      STDERR::puts "Can't test MapQuery API unless you specify a MAPQUEST_API_KEY in geox_api_keys.rb"
      assert true
    else
      location = {:address => '700 19th', :city => 'San Francisco', :state => 'CA'}
      geocoder = GeoX::Geocoder.new(:geoengine => GeoX::MapQuest)
      locations = geocoder.geocode(location)
      # should code 19th Ave and 19th St
      assert_equal 2, locations.size
      expected = ['Avenue', 'Street']
      locations.each do |location|
        expected.delete('Avenue') if location.address.upcase == '700 19TH AVENUE'
        expected.delete('Street') if location.address.upcase == '700 19TH STREET'
        assert location.kind_of?(GeoX::Street)
      end
      assert expected.blank?, "We should not have found Avenue or Street but did find: #{expected.inspect}"

      # prove we get back street addresses that are correctly formed
      location = {:address => '1711 Martin Luther King Junior Wy', :city => 'Berkeley', :state => 'CA'}
      locations = geocoder.geocode(location)
      assert_equal 1, locations.size
      assert_equal "1711 MARTIN LUTHER KING JR WAY", locations[0].address.upcase
      assert locations[0].kind_of?(GeoX::Street)

      # show that MapQuest improperly (imo) gives back multiple geocodes for a
      # single, unambiguous street intersection -- in this case it returns ZIP5 and ZIP9 geocodes (wtf)
      location = {:address => 'Virginia St @ Milvia St', :city => 'Berkeley', :state => 'CA'}
      locations = geocoder.geocode(location)
      assert_equal 2, locations.size
      # turn on duplicate detection and show that now we only get one geocode at the block level
      locations = geocoder.geocode(location, :remove_duplicates => true)
      assert_equal 1, locations.size
      assert locations[0] == GeoX::Block
      # show intersection conversion is working
      assert_equal "VIRGINIA STREET AT MILVIA STREET", locations[0].address.upcase
      # show that setting remove duplicates above via .geocode will permanently turn on duplicate detection
      locations = geocoder.geocode(location, :preserve_intersections => true)
      assert_equal 1, locations.size
      assert_equal "VIRGINIA STREET @ MILVIA STREET", locations[0].address.upcase
      # show we can turn off remove_duplicates again
      locations = geocoder.geocode(location, :remove_duplicates => false, :preserve_intersections => false)
      # show that we correctly unmunge intersections for multiple addresses
      assert_equal 2, locations.size
      locations.each do |loc|
        assert_equal "VIRGINIA STREET AT MILVIA STREET", loc.address.upcase
      end
    end #if/else MAPQUEST_API_KEY.blank?
  end

  # the intersection converter should be "nice" about remembering what the previous intersection used was
  # this could present problems if you are running unmapquest_intersection for various addresses
  # without previously running "mapquest_intersections" for same - but why would you do that? :)
  def test_maquest_intersections
    geocoder = GeoX::MapQuest.new
    # test that we correctly convert various intersections to/from mapquest format
    # should use default " AT " for intersection
    assert_equal "Milvia AT Francisco", geocoder.unmapquest_intersection!("Milvia @ Francisco")
    assert_equal "Milvia @ Francisco", geocoder.mapquest_intersection!("Milvia at Francisco")
    # should remember case from previous coding
    assert_equal "Milvia at Francisco", geocoder.unmapquest_intersection!("Milvia @ Francisco")
    assert_equal "AtMilvia Rd @ xFrancisco Pk", geocoder.mapquest_intersection!("AtMilvia Rd X xFrancisco Pk")
    # should remember intersection from previous
    assert_equal "AtMilvia Rd X xFrancisco Pk", geocoder.unmapquest_intersection!("AtMilvia Rd @ xFrancisco Pk")
  end

  # geocode instances should be comparable both with themselves and with GeoX::Geocode Classes
  def test_geocode_class_comparisons
    assert true
    location = {:address => '700 19th', :city => 'San Francisco', :state => 'CA'}
    street = GeoX::Street.new(:location => location)
    block = GeoX::Block.new(:location => location)
    postcode = GeoX::PostCode.new(:location => location)
    city = GeoX::City.new(:location => location)
    unknown = GeoX::Unknown.new(:location => location)
    assert street == GeoX::Street
    assert street < block
    assert street < GeoX::Block
    assert block > street
    assert block > GeoX::Street
    assert postcode > block
    assert postcode < city
    assert city < GeoX::Unknown
    assert unknown > city
    assert unknown > GeoX::PostCode

  end
end
