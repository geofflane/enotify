class GeoLocation < ActiveRecord::Base  
  validates_uniqueness_of :latitude, :scope => [:longitude]
  validates_presence_of :latitude, :longitude
  validates_numericality_of :latitude, :longitude
  
  has_many :incidents
  has_many :service_requests
  has_many :permit_records
  
  def to_s
    "#{latitude}, #{longitude}"
  end
end
