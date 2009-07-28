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


class RecordingAppParser
  RECORDING_REGEX = /At (.*) \(taxkey # ([\d-]+)\), there is a new recording application ([#\d]+)/
  
  def parse(text, city, state) 
    street, tax_key, record_number = RECORDING_REGEX.match(text).captures
    recording_app = RecordingApplication.find_or_create_by_record_number(record_number)
    recording_app.tax_key = tax_key
   
    recording_app.address = Address.find_or_create_by_street_and_city_and_state(street, city, state)

    recording_app.incident_time = Time.new

    recording_app
  end
  
end
