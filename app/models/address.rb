class Address  < ActiveRecord::Base  
  
  STREET_REGEX = /([\d]+) (.*)/
  
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
  
  def self.existing_or_new(street, city, state)
    a = Address.find(:first, :conditions => ["street=:street AND city=:city AND state=:state", 
        { :street => street, :city => city, :state => state }])
    a = Address.new(:street => street, :city => city, :state => state) if ! a
    a
  end

  def to_s
    addr = street
    addr << " #{city}" if city
    addr << ',' if city && state
    addr << " #{state}" if state
    addr << " #{full_zip}" if full_zip
    addr
  end
end
