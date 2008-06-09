class Address  < ActiveRecord::Base  
  has_many :incidents
  has_many :service_requests
  has_many :permit_records
  
  belongs_to :geo_location
  
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
    addr << " #{zip}" if zip
    addr
  end
end
