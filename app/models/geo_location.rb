class GeoLocation < ActiveRecord::Base  
  has_many :incidents
  has_many :service_requests
  has_many :permit_records

  def to_s
    "#{lat}, #{long}"
  end
end
