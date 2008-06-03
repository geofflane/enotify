require 'geox'

class GeoLocationLookup
  # attr_reader :geocoder

  def initialize()
    @geocoder = GeoX::Geocoder.new(:geoengine => GeoX::Yahoo) 
  end

  def lookup(incident)
    orig_add = incident.address
    location = {:address => orig_add.street1, :city => orig_add.city, :state => orig_add.state }
    geocode = @geocoder.geocode(location)
    
    incident.address = Address.new(orig_add.street1, orig_add.city, orig_add.state, geocode[0].post_code)
    incident.geo_location = GeoLocation.new(geocode[0].longitude, geocode[0].latitude)
    incident
  end

end
