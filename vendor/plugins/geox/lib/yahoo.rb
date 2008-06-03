require 'geocode_engine'

module GeoX
  # Parts of this code are lifted or adapted shamelessly from http://blog.apokalyptik.com/software/ruby-mapquest/
  class Yahoo < GeoX::GeocodeEngine

    # you must set the YAHOO_API_KEY constant in init.rb!
    def initialize(options = {})
      @api_key = options[:api_key] || GeoX::YAHOO_API_KEY
      if options[:api_url_base].blank?
        @api_url_base = "http://local.yahooapis.com/MapsService/V1/geocode?"
      else
        @api_url_base = options[:api_url_base]
      end
      self.set_options(options)
    end

    # returns an array of GeoX::Geocode instances (Street, City, etc)
    # First instance is "best guess"
    # If only one instance is returned, it represents best guess as to location
    def geocode(location, options = {})
      if location.blank? : raise(GeoErrorParameter, "Location hash is required in geocode method"); end
      self.set_options(options)
      #http://local.yahooapis.com/MapsService/V1/geocode?appid=YahooDemo&street=701+First+Street&city=Sunnyvale&state=CA
      url = []
      url << @api_url_base
      url << "appid=#{@api_key}"
      url << "street="     + CGI::escape(location[:address])   if !location[:address].blank?
      url << "city="       + CGI::escape(location[:city])      if !location[:city].blank?
      #url << "county="     + CGI::escape(location[:county])    if !location[:county].blank?
      url << "state="      + CGI::escape(location[:state])     if !location[:state].blank?
      url << "zip="        + CGI::escape(location[:post_code])  if !location[:post_code].blank?
      url << "output=xml"
      url = url.join("&")
      begin
        response = Hpricot(open(url))
      rescue
        return [GeoX::NetFailure.new]
      end
      # return the array provided by parse location
      parse_locations(response, options)
    end

    protected

    attr_accessor :remove_duplicates, :preserve_intersections

    def set_options(options)
      super(options)
    end

    # returns :street, :block, :post_code, :city, :multiple, :unknown
    def parse_locations(response, options = {})
      retval = []
      # we want all <location> tags that are in a <locations> tag alongsinde a status tag:
      # <locations><status>xx</status><location>!!</location></locations>
      # (there are other  <locations> tags that have <location> tags but no <status> tags: we don't want these)
      response.search('//resultset/result').each do |location|
      if location[:warning].blank?
        case location[:precision]
          when 'address'
            geocode = GeoX::Street.new
          when 'street'
            geocode = GeoX::Block.new
          when 'zip', 'zip+2', 'zip+4'
            geocode = GeoX::PostCode.new
          when 'city'
            geocode = GeoX::City.new
          else
            geocode = GeoX::Unknown.new
        end # case..
        # handle Yahoo is braindead: it returns zip precision sometimes when zip code is blank and city is present (meaning it doesn't really have a zip geocode)
        if location[:precision].match(%r{^zip}) && location.search('zip').inner_html.blank? && 
         !location.search('city').inner_html.blank? && geocode <= GeoX::PostCode
          geocode = GeoX::City.new
        end
      else
        geocode = GeoX::Unknown.new
        geocode.warnings = location[:warning]
      end # if location..
      geocode.address = location.search('address').inner_html
      geocode.city = location.search('city').inner_html
      geocode.state = location.search('state').inner_html
      geocode.country = location.search('country').inner_html
      geocode.post_code = location.search('zip').inner_html
      geocode.longitude = location.search('longitude').inner_html
      geocode.latitude = location.search('latitude').inner_html
      retval << geocode
      end
      remove_duplicate_geocodes(retval) if self.remove_duplicates?
      retval
    end #generate_location

    # Yahoo API Request parameters
    # appid     string (required)     The application ID. See Application IDs for more information.
    # street   string   Street name. The number is optional.
    # city   string   City name.
    # state   string   The United States state. You can spell out the full state name or you can use the two-letter abbreviation.
    # zip   integer or <integer>-<integer>   The five-digit zip code, or the five-digit code plus four-digit extension. If this location contradicts the city and state specified, the zip code will be used for determining the location and the city and state will be ignored.
    # location   free text
    #  This free field lets users enter any of the following:
    #    * city, state
    #    * city, state, zip
    #    * zip
    #    * street, city, state
    #    * street, city, state, zip
    #    * street, zip
    #  If location is specified, it will take priority over the individual fields in determining the location for the query. City, state and zip will be ignored.
    #  output   string: xml (default), php   The format for the output. If php is requested, the results will be returned in Serialized PHP format.

  end
end # GeoX