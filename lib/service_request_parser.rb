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


class ServiceRequestParser
  SERVICE_REGEX = /At (.*) \(taxkey # ([\d-]+)\), there is a new service request record ([#\d]+)/
  COMPLAINT_REGEX = /Complaint description: (.+) Please click link below/
  
  def parse(text, city, state) 
    service_request = ServiceRequest.new
    
    street, service_request.tax_key, service_request.record_number = SERVICE_REGEX.match(text).captures
    service_request.address = Address.find_or_create_by_street_and_city_and_state(street, city, state)
    
    service_request.description = COMPLAINT_REGEX.match(text).captures[0]
    service_request.incident_time = Time.new

    service_request
  end
  
end