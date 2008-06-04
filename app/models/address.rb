class Address
  attr_accessor :street, :city, :state, :zip

  def initialize(street=nil, city=nil, state=nil, zip=nil)
    @street = street
    @city = city
    @state = state
    @zip = zip
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
