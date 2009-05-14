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

class Incident < ActiveRecord::Base
  # record_number, description, tax_key, time
  
  validates_presence_of :record_number
  
  belongs_to :enotify_mail
  belongs_to :address
  belongs_to :geo_location
  
  acts_as_ferret :fields => [:record_number, :description, :tax_key, :enotify_mail_clean_text, :address_text]

  def self.find_all_years
    self.connection.select_values("SELECT DISTINCT(year(incident_time)) FROM #{self.quoted_table_name} ORDER BY year(incident_time)")
  end
  
  def self.find_all_months(year)
    self.connection.select_values("SELECT DISTINCT(month(incident_time)) FROM #{self.quoted_table_name} WHERE year(incident_time)='#{year}' ORDER BY month(incident_time)")
  end

  # really for AAF
  def enotify_mail_clean_text
    enotify_mail.clean_text
  end
  
  def address_text
    address.to_s
  end
  
  def tax_key_clean
    tax_key.gsub(/[#-]/, '') if tax_key
  end
  
  def local_time
    incident_time.localtime
  end
  
  cattr_reader :per_page
  @@per_page = 25

  named_scope :same_block, lambda { |address| { :joins => :address, :conditions => ["addresses.street_number between ? and ? AND addresses.street_name=? AND addresses.zip=?", address.block_start, address.block_end, address.street_name, address.zip], :include => [:address, :geo_location] } }
  # :joins => :address, :conditions => ["addresses.street_number between ? and ? AND addresses.street_name=? AND addresses.zip=?", address.block_start, address.block_end, address.street_name, address.zip]
  named_scope :by_record_number,  lambda { |record_number| { :conditions => ["record_number=?", record_number], :include => [:address, :geo_location] } }

  # Location based limits
  named_scope :by_address_id,  lambda { |address_id| { :conditions => ["address_id=?", address_id], :include => [:address, :geo_location] } }
  named_scope :in_zip,  lambda { |zip| { :joins => :address, :conditions => ["addresses.zip=?", zip], :include => [:address, :geo_location] } }
  named_scope :on_street, lambda { |street, zip| { :joins => :address, :conditions => ["addresses.street_name=? AND addresses.zip=?", street, zip], :include => [:address, :geo_location] } }
  named_scope :between_addresses, lambda { |start_number, end_number, street, zip| 
    { :joins => :address, :conditions => ["addresses.street_number between ? and ? AND addresses.street_name=? AND addresses.zip=?", start_number, end_number, street, zip], :include => [:address, :geo_location] } }
  
  # Time based limits
  named_scope :recent, :conditions => ["incident_time > ?", 4.weeks.ago], :include => [:address, :geo_location]
  named_scope :in_year, lambda { |year| { :conditions => ["incident_time between ? and ?", Date.parse("1/1/#{year}"), Date.parse("12/31/#{year}")], :include => [:address, :geo_location] } }
  named_scope :in_month, lambda { |month, year| { :conditions => ["incident_time between ? and ?", *Date.parse("#{month}/1/#{year}").beginning_and_end_of_month], :include => [:address, :geo_location] } }

  def same_block
    self.class.same_block(address)
  end

  def to_kml
    xm = Builder::XmlMarkup.new
    xm.instruct!
    xm.kml("xmlns"=>"http://earth.google.com/kml/2.2") {
      xm.Document {
        build_kml_body(xm)
      }
    }
  end
  
  def build_kml_body(xm)
    xm.Placemark {
      xm.name(record_number)
      xm.description { xm.cdata!("#{address.to_s}\n#{description}") }
      xm.Location {
        xm.latitude(geo_location.latitude)
        xm.longitude(geo_location.longitude)
      }
      xm.Point { xm.coordinates(geo_location.to_formatted_s(:kml)) }
    }
  end

  def to_ical
    event = Icalendar::Event.new

    event.dtend        incident_time.to_formatted_s(:ical)
    event.dtstart      incident_time.to_formatted_s(:ical)
    event.summary      description
    event.categories   [self.class.name.humanize]
    event.location     address.to_s.split("\n").join(' ')
    event.geo_location geo_location.to_formatted_s(:ical)
    event.description """Record Number: #{record_number}
Address: #{address.to_s}
Tax Key: #{tax_key}
"""
    event
  end

end
