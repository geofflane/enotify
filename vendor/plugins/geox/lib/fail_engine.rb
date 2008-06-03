require 'geocode_engine'

module GeoX
  # Parts of this code are lifted or adapted shamelessly from http://blog.apokalyptik.com/software/ruby-mapquest/
  # Failure adapter is for testing - it always fails with a network error, and never succeeds
  class NetFail < GeoX::GeocodeEngine

    def initialize(options = {})
    end
    
    # geocodes for the Failure class always return failure
    # other engines can return Failure instances too, so you must check for them
    def geocode(location, options = {})
      return [GeoX::NetFailure.new]
    end
  end
end # GeoX