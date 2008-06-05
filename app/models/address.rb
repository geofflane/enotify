class Address  < ActiveRecord::Base  
  has_many :incidents
  has_many :service_requests
  has_many :permit_records
  
  belongs_to :geo_location

  def to_s
    addr = street
    addr << " #{city}" if city
    addr << ',' if city && state
    addr << " #{state}" if state
    addr << " #{zip}" if zip
    addr
  end
end
