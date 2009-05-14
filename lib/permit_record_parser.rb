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


class PermitRecordParser
  PERMIT_REGEX = /At (.*) \(taxkey # ([\d-]+)\), there is a new permit record ([#\d]+)/
  TYPE_REGEX = /Permit type: (.+) Please click link below/
  
  def parse(text, city, state) 
    permit_record = PermitRecord.new
    
    street, permit_record.tax_key, permit_record.record_number = PERMIT_REGEX.match(text).captures
    permit_record.address = Address.find_or_create_by_street_and_city_and_state(street, city, state)
    
    permit_record.description = TYPE_REGEX.match(text).captures[0]
    permit_record.incident_time = Time.new

    permit_record
  end
  
end
