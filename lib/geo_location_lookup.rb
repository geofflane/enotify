# Milwaukee Enotify Deconstructed
# Copyright (C) 2009 Geoff Lane <geoff@zorched.net>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
