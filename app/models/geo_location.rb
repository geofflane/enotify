class GeoLocation < ActiveRecord::Base  
  has_many :incidents
  has_many :service_requests
  has_many :permit_records

  def self.existing_or_new(lat, long)
    gl = GeoLocation.find(:first, :conditions => ["lat=:lat AND long=:long", 
        { :lat => lat, :long => long }])
    gl = GeoLocation.new(:lat => lat, :long => long) if ! gl
    gl
  end
  
  def to_s
    "#{lat}, #{long}"
  end
end
