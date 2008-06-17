class Incident < ActiveRecord::Base
  validates_uniqueness_of :record_number
  validates_presence_of :record_number
  
  acts_as_temporal
  acts_as_locatable
  
  belongs_to :enotify_mail
  belongs_to :address
  belongs_to :geo_location
  
  # record_number, description, tax_key, time

  def to_ical
    event = Icalendar::Event.new

    event.dtend        incident_time.strftime("%Y%m%dT%H%M%S")
    event.dtstart      incident_time.strftime("%Y%m%dT%H%M%S")
    event.summary      record_number
    event.categories   [self.class.name.humanize]
    event.location     address.to_s.split("\n").join(' ')
    event.geo_location geo_location.to_s
    event.description """#{description}
Address: #{address.to_s}
Tax Key: #{tax_key}
"""
    event
  end

end
