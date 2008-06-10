class GeoLocation < ActiveRecord::Base  
  has_many :incidents
  has_many :service_requests
  has_many :permit_records

  def self.existing_or_new(lat, long)
    gl = GeoLocation.find(:first, :conditions => ["latitude=:latitude AND longitude=:longitude", 
        { :latitude => lat, :longitude => long }])
    gl = GeoLocation.new(:latitude => lat, :longitude => long) if ! gl
    gl
  end
  
  def to_s
    "#{latitude}, #{longitude}"
  end
end
