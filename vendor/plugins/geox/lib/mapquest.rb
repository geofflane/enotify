require 'geocode_engine'

module GeoX
  # GeoX::MapQuest class provides geocode capability via the mapquest.com REST interface
  # Parts of this code are lifted or adapted shamelessly from http://blog.apokalyptik.com/software/ruby-mapquest/
  class MapQuest < GeoX::GeocodeEngine

    # you must set the MAPQUEST_API_KEY constant in init.rb!
    def initialize(options = {})
      @api_key = options[:api_key] || GeoX::MAPQUEST_API_KEY
      if options[:api_url_base].blank?
        @api_url_base = "http://web.openapi.mapquest.com/oapi/transaction"
      else
        @api_url_base = options[:api_url_base]
      end
      self.set_options(options)
    end

    # returns an array of GeoX::Geocode instances (Street, City, etc)
    # First instance is "best guess"
    # If only one instance is returned, it represents best guess as to location
    # MAPQUEST-SPECIFIC OPTIONS (setting options alters them on future calls as well):
    # remove_duplicates => true causes engine prevent multiple identical lat/long results
    #  from being returned (MapQuest will sometimes return multiple options that have identical lat/long
    #  coordinates, which is pretty useless for many applications)
    # preserve_intersections => true will prevent engine from altering input and output addresses
    #  when dealing with intersections - MapQuest wants intersections presented with "@" and most
    #  outside applications expect intersections as "Street at Street" or "Street x Street"
    #  Normally this engine will process certain characters as intersections converting them to "@"
    #  for geocoding purposes. Similarly, on output, engine will convert "@" to "AT"
    def geocode(location, options = {})
      if location.blank? : raise(GeoErrorParameter, "Location hash is required in geocode method"); end
      self.set_options(options)
      address = location[:address]
      self.mapquest_intersection!(address) if !self.preserve_intersections?
      url = []
      url << "#{@api_url_base}?transaction=geocode"
      url << "key=#{@api_key}"
      url << "address="       + CGI::escape(address)              if !address.blank?
      url << "city="          + CGI::escape(location[:city])      if !location[:city].blank?
      url << "county="        + CGI::escape(location[:county])    if !location[:county].blank?
      url << "stateProvince=" + CGI::escape(location[:state])     if !location[:state].blank?
      url << "postalcode="    + CGI::escape(location[:post_code])  if !location[:post_code].blank?
      url << "country="       + CGI::escape(location[:country])   if !location[:country].blank?
      url = url.join("&")
      begin
        response = Hpricot(open(url))
      rescue
        return [GeoX::NetFailure.new]
      end
      # return the array provided by parse location
      parse_locations(response)
    end

    # converts address to mapquest compatible intersection format
    def mapquest_intersection!(address)
      intersection_regex = %r{ AT | X | AND | & }i
      @orig_intersection = address.match(intersection_regex) if !address.blank?
      @orig_intersection = @orig_intersection ? @orig_intersection[0].strip : nil
      address.sub!(intersection_regex, ' @ ') if !address.blank?
      address
    end

    # converts address from mapquest compatible intersection format
    def unmapquest_intersection!(address)
      # we try to use the original intersection but use " AT " if none is available
      replacement_intersection = @orig_intersection || 'AT'
      address.sub!(%r{ @ }, " #{replacement_intersection} ")
      address
    end

    protected

    attr_accessor :preserve_intersections

    def set_options(options)
      super(options)
      self.preserve_intersections = !!options[:preserve_intersections] if options.include?(:preserve_intersections)
    end

    def preserve_intersections?
      self.preserve_intersections
    end

    # returns :street, :block, :post_code, :city, :multiple, :unknown
    def parse_locations(response)
      retval = []
      # we want all <location> tags that are in a <locations> tag alongsinde a status tag:
      # <locations><status>xx</status><location>!!</location></locations>
      # (there are other  <locations> tags that have <location> tags but no <status> tags: we don't want these)
      response.search('//locations/status/../location').each do |location|
        case location.search('geocodequality').inner_html
          when 'ADDRESS'
            geocode = GeoX::Street.new
          when 'STREET', 'INTERSECTION'
            geocode = GeoX::Block.new
          when 'ZIP', 'ZIP7', 'ZIP9'
            geocode = GeoX::PostCode.new
          when 'CITY', 'COUNTY'
            geocode = GeoX::City.new
          else
            geocode = GeoX::Unknown.new
        end
        address = location.search('address').inner_html
        # convert "@" intersections to "AT" intersection format if permitted
        self.unmapquest_intersection!(address) if !self.preserve_intersections?
        geocode.address = address
        geocode.city = location.search('city').inner_html
        geocode.county = location.search('county').inner_html
        geocode.state = location.search('stateprovince').inner_html
        geocode.country = location.search('country').inner_html
        geocode.post_code = location.search('postalcode').inner_html
        geocode.longitude = location.search('longitude').inner_html
        geocode.latitude = location.search('latitude').inner_html
        retval << geocode
      end
      self.remove_duplicate_geocodes(retval) if self.remove_duplicates?
      retval
    end #generate_location


    # MapQuest API Request parameters
    #key OpenAPI key you received at signup (required).
    #name Name of the location.
    #address Street number and name, including road type and directionals when possible such as "33 North Main Street."
    #city City or town.
    #county Identifies the county of the location.
    #stateProvince State or province.
    #postalCode Postal code. For USA addresses, this can be a ZIP, ZIP+2, or ZIP+4 code.
    #country The two-letter country code as defined by the ISO 3166 standard. The default is US. ambiguities When set to 1 (the default), the server may return ambiguous geocoding results when supplying any locations with address elements such as street and city. Set to 0 to suppress this behavior. See "Ambiguous Geocoding Results" on page 13 for details.

    # sample request:
    # http://web.openapi.mapquest.com/oapi/transaction?transaction=geocode&address=122%20n%20plum%20st&city=lancaster&stateProvince=pa&key=xyz


    # Status attribute of Response node
    #NOTE: The status attribute of the Response node summarizes the high-level success of the
    #transaction. If 0, there were no errors or unusual conditions. If 1, ambiguous geocoding results are
    #included. If 2, at least one geocoded address was a single location match although not exactly as
    #entered. If 4, at least one geocoded address returned no location matches at all. If 8, there is a route
    #gap between either the origin and the actual start of the route or between the end of the route and the
    #destination.

    # GeocodeStatus field
    #1000 Single non-exact address match.
    #1010 Single non-exact street block match.
    #1011 Single exact street block match.
    #1020 Single ZIP+4 postal code (or international equivalent), fallback from address.
    #1021 Single ZIP+2 postal code (or international equivalent), fallback from address.
    #1022 Single postal code, fallback from address.
    #1030 Single fallback from address to city level.
    #1031 Single fallback from postal code to city level.
    #1040 Single fallback from address to state level.
    #1041 Single fallback from postal code to state level.
    #1050 Single fallback from a postal code to country. This will occur only when the postal code was invalid.
    #1100 Multiple non-exact address matches.
    #1110 Multiple non-exact street block matches.
    #1111 Multiple exact street block matches.
    #1120 Multiple ZIP+4 postal codes (or international equivalent), fallback from address.
    #1121 Multiple ZIP+2 postal codes (or international equivalent), fallback from address.
    #1122 Multiple postal codes, fallback from address.
    #1123 Multiple postal codes.
    #1130 Multiple fallback from address to city level.
    #1131 Multiple fallback from postal code to city level.
    #1132 Multiple city match with no fallback.
    #1140 Multiple fallback from address to state level.
    #1141 Multiple fallback from postal code to state level.
    #1142 Multiple state match no fallback
    #1900 No fallback and no ambiguity. For example, if a full street address with a house number was input, it matched server data exactly. If the input address was merely a city and state, it matched server data exactly.
    #1901 Geocoding failed. No address matches found.
    #1902 Invalid state or province.
    #1903 Invalid two-character ISO 3166 country code.

    # Ruby code for parsing these codes into Geocode instances
    #locationstatus = response.search('//locations/status').inner_html
    #case locationstatus
    #  # street level
    #  when '1900', '1000'
    #    retval = GeoX::Street.new
    #  # block level
    #  when '1010', '1011'
    #    retval  GeoX::Block.new
    #  # postcode level
    #  when '1020', '1021', '1022',
    #    retval = GeoX::Postcode.new
    #  # city level
    #  when '1030', '1031'
    #    retval = GeoX::City.new
    #  # multiple responses
    #  when '1100','1110','1111','1120','1121','1122','1123','1130','1131','1132'
    #    retval = GeoX::Multiple.new
    #  else
    #    retval = GeoX::Unknown.new
    #end # case

    # GeocodeQuality field
    #ADDRESS The location describes a full street address. The coordinates should be on the correct block, but are not guaranteed to be precisely positioned on that block.
    #STREET The location describes a block on a street or an entire street. The returned latitude and longitude are a representative location for the block or street. If the input street number was provided but seems too high or too low to be valid, the coordinates may represent the closest valid block on that street near the input address.
    #INTERSECTION The location describes an intersection of two streets.
    #ZIP The location is the weighted center of the postal code, typically a low accuracy postal code. In the USA, this is a 5-digit ZIP code.
    #ZIP7 The location is the weighted center of the postal code, typically a medium accuracy postal code. In the US, a 7-digit ZIP code. This is a standard Canadian postal code.
    #ZIP9 The location is the weighted center of the postal code, typically a high accuracy postal code. In the US, a 9-digit ZIP code.
    #CITY The location is the weighted center of the city.
    #COUNTY The location is the weighted center of the county.
    #STATE The location is the weighted center of the state or province.
    #COUNTRY The location is the weighted center of the country. This is the fallback geocoding return value if no valid address elements were entered.
    #NO_GEOCODE No geocoding occurred. The location was supplied in a request with explicit latitude and longitude coordinates.

  end
end # GeoX