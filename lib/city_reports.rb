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

class CityReports
  attr_accessor :parser, :city, :state

  def initialize(parser, geo_lookup, city, state)
    @parser = parser
    @geo_lookup = geo_lookup
    @city = city
    @state = state
  end

  def build_report(text)
    report = @parser.parse(text, @city, @state)
    if report.address 
      if report.address.geo_location
        report.geo_location = report.address.geo_location if report.address.geo_location
      else
        report = @geo_lookup.lookup(report) 
      end
    end
    report
  end
  
end
