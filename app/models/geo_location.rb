class GeoLocation
  attr_accessor :long, :lat
  
  def initialize(longitude=0, latitude=0)
    @long = longitude
    @lat = latitude
  end

  def to_s
    "#{@long}, #{@lat}"
  end
end
