class Address
  attr_accessor :street1, :street2, :city, :state, :zip

  def initialize(street1=nil, city=nil, state=nil, zip=nil)
    @street1 = street1
    @city = city
    @state = state
    @zip = zip
  end

  def to_s
    addr = street1
    addr << " #{street2}" if street2
    addr << " #{city}" if city
    addr << ',' if city && state
    addr << " #{state}" if state
    addr << " #{zip}" if zip
    addr
  end
end
