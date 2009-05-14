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

class Address  < ActiveRecord::Base  
  
  STREET_REGEX = /([\d]+) (.*)/
  
  validates_numericality_of :street_number
  validates_length_of :zip, :maximum => 7
  validates_length_of :full_zip, :maximum => 10
  validates_length_of :state, :is => 2
  
  # street, city, state, zip, street_number, full_zip, street_name
  
  has_many :incidents
  has_many :service_requests
  has_many :permit_records
  
  belongs_to :geo_location
  
  def block_start
    street_number / 100 * 100   # / 100 keeps it as a whole number, so we lose the remainder
  end
  
  def block_end
    block_start + 99
  end
  
  def street=(st)
    write_attribute('street', st)
    num, name = STREET_REGEX.match(st).captures
    write_attribute('street_number', num)
    write_attribute('street_name', name)
  end
  
  def full_zip=(fz)
    write_attribute('full_zip', fz)
    write_attribute('zip', fz.split('-')[0])
  end

  def to_s
    addr = street + "\n"
    addr << " #{city}" if city
    addr << ',' if city && state
    addr << " #{state}" if state
    addr << " #{full_zip}" if full_zip
    addr
  end
end
