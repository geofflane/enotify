require 'geox'

class GeoLocationLookup

  def initialize()
    @geocoder = GeoX::Geocoder.new(:geoengine => GeoX::Yahoo) 
  end

  def lookup(report)
    location = {:address => report.address.street, :city => report.address.city, :state => report.address.state }
    geocode = @geocoder.geocode(location)
    
    geo_location = GeoLocation.existing_or_new(geocode[0].latitude, geocode[0].longitude)
    report.address.full_zip = geocode[0].post_code
    report.address.geo_location = geo_location
    report.geo_location = geo_location
    report
  end

end
