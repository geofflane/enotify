class Incident < ActiveRecord::Base
  validates_uniqueness_of :record_number
  validates_presence_of :record_number
  
  belongs_to :enotify_mail
  belongs_to :address
  belongs_to :geo_location
  
  # record_number, description, tax_key, time

  def self.find_by_zip(zip)
    find(:all, :joins => [:address], :conditions => ["addresses.zip=?", zip])
  end
  
  def self.find_by_street(street, zip)
    find(:all, :joins => [:address], :conditions => ["addresses.street_name=? AND addresses.zip=?", street, zip])
  end
  
  def self.find_by_address(start_number, end_number, street, zip)
    find(:all, :joins => [:address], :conditions => ["addresses.street_number between ? and ? AND addresses.street_name=? AND addresses.zip=?", start_number, end_number, street, zip])
  end
  
  def self.find_by_month_and_year(month, year)
    start = Date.parse("#{month}/1/#{year}").beginning_of_month
    find(:all, :conditions => ["incident_time between ? and ?", start.yesterday.end_of_day, start.end_of_month.end_of_day])
  end

  def to_ical
    event = Icalendar::Event.new

    event.dtend        incident_time.strftime("%Y%m%dT%H%M%S")
    event.dtstart      incident_time.strftime("%Y%m%dT%H%M%S")
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
