require 'geox'

class GeoLocationLookup

  def initialize()
    @geocoder = GeoX::Geocoder.new(:geoengine => GeoX::Yahoo) 
  end

  def lookup(report)
    orig_add = report.address
    location = {:address => orig_add.street, :city => orig_add.city, :state => orig_add.state }
    geocode = @geocoder.geocode(location)
    
    report.address = Address.new(orig_add.street, orig_add.city, orig_add.state, geocode[0].post_code)
    report.geo_location = GeoLocation.new(geocode[0].longitude, geocode[0].latitude)
    report
  end

end
