class Incident < ActiveRecord::Base
  # record_number, description, tax_key, time

  validates_presence_of :record_number
  
  belongs_to :enotify_mail
  belongs_to :address
  belongs_to :geo_location
  
  acts_as_ferret :fields => [:record_number, :description, :tax_key, :enotify_mail_clean_text, :address_text]

  # really for AAF
  def enotify_mail_clean_text
    enotify_mail.clean_text
  end
  
  def address_text
    address.to_s
  end

  # Location based limits
  named_scope :in_zip,  lambda { |zip| { :joins => :address, :conditions => ["addresses.zip=?", zip] } }
  named_scope :on_street, lambda { |street, zip| { :joins => :address, :conditions => ["addresses.street_name=? AND addresses.zip=?", street, zip] } }
  named_scope :between_addresses, lambda { |start_number, end_number, street, zip| 
    { :joins => :address, :conditions => ["addresses.street_number between ? and ? AND addresses.street_name=? AND addresses.zip=?", start_number, end_number, street, zip] } }
  
  # Time based limits
  named_scope :recent, :conditions => ["incident_time > ?", 4.weeks.ago]
  named_scope :in_month, lambda { |month, year| { :conditions => ["incident_time between ? and ?", *Date.parse("#{month}/1/#{year}").beginning_and_end_of_month] } }

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
