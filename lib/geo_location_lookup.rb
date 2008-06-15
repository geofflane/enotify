require 'geox'

class GeoLocationLookup

  def initialize()
    @geocoder = GeoX::Geocoder.new(:geoengine => GeoX::Yahoo) 
  end

  def lookup(report)
    location = {:address => report.address.street, :city => report.address.city, :state => report.address.state }
    geocode = @geocoder.geocode(location)

    if (geocode)
      geocode.each do |g|
        Rails.logger.error("GGGG: #{g.latitude}, #{g.longitude}, #{g.post_code}")
      end
    end
        
    geo_location = GeoLocation.find_or_create_by_latitude_and_longitude(geocode[0].latitude, geocode[0].longitude)
    
    report.address.full_zip = geocode[0].post_code
    report.address.geo_location = geo_location
    report.geo_location = geo_location
    report
  end

end
