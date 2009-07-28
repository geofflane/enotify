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

class GeoLocation < ActiveRecord::Base  
  validates_uniqueness_of :latitude, :scope => [:longitude]
  validates_presence_of :latitude, :longitude
  validates_numericality_of :latitude, :longitude
  
  has_many :incidents
  has_many :service_requests
  has_many :permit_records
    
  def to_s
    to_formatted_s()
  end

  def to_formatted_s(format = :default)
    if format == :ical
      "#{latitude};#{longitude}"
    elsif format == :kml
      "#{longitude},#{latitude},0"
    else
      "#{latitude}, #{longitude}"
    end
  end
end
