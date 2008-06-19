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
