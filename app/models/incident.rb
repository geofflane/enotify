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
  
  cattr_reader :per_page
  @@per_page = 25

  named_scope :same_block, lambda { |address| { :joins => :address, :conditions => ["addresses.street_number between ? and ? AND addresses.street_name=? AND addresses.zip=?", address.block_start, address.block_end, address.street_name, address.zip] } }
  # :joins => :address, :conditions => ["addresses.street_number between ? and ? AND addresses.street_name=? AND addresses.zip=?", address.block_start, address.block_end, address.street_name, address.zip]
  named_scope :by_record_number,  lambda { |record_number| { :conditions => ["record_number=?", record_number] } }

  # Location based limits
  named_scope :by_address_id,  lambda { |address_id| { :conditions => ["address_id=?", address_id] } }
  named_scope :in_zip,  lambda { |zip| { :joins => :address, :conditions => ["addresses.zip=?", zip] } }
  named_scope :on_street, lambda { |street, zip| { :joins => :address, :conditions => ["addresses.street_name=? AND addresses.zip=?", street, zip] } }
  named_scope :between_addresses, lambda { |start_number, end_number, street, zip| 
    { :joins => :address, :conditions => ["addresses.street_number between ? and ? AND addresses.street_name=? AND addresses.zip=?", start_number, end_number, street, zip] } }
  
  # Time based limits
  named_scope :recent, :conditions => ["incident_time > ?", 4.weeks.ago]
  named_scope :in_month, lambda { |month, year| { :conditions => ["incident_time between ? and ?", *Date.parse("#{month}/1/#{year}").beginning_and_end_of_month] } }

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
