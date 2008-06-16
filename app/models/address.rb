class Address  < ActiveRecord::Base  
  
  STREET_REGEX = /([\d]+) (.*)/
  
  validates_numericality_of :street_number
  validates_length_of :zip, :maximum => 7
  validates_length_of :full_zip, :maximum => 10
  validates_length_of :state, :is => 2
  
  # street, city, state, zip, street_number, full_zip, street_name
  
  has_many :incidents
  has_many :service_requests
  has_many :permit_records
  
  belongs_to :geo_location
  
  def street=(st)
    write_attribute('street', st)
    num, name = STREET_REGEX.match(st).captures
    write_attribute('street_number', num)
    write_attribute('street_name', name)
  end
  
  def full_zip=(fz)
    write_attribute('full_zip', fz)
    write_attribute('zip', fz.split('-')[0])
  end

  def to_s
    addr = street + "\n"
    addr << " #{city}" if city
    addr << ',' if city && state
    addr << " #{state}" if state
    addr << " #{full_zip}" if full_zip
    addr
  end
end
