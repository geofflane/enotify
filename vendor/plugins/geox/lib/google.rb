require 'geocode_engine'

module GeoX
  # Parts of this code are lifted or adapted shamelessly from http://blog.apokalyptik.com/software/ruby-mapquest/
  class Google < GeoX::GeocodeEngine

    # locale stores locale options for URL line in url parameter format (i.e. "oe=utf8")
    attr_accessor :locale

    # you must set the GOOGLE_API_KEY constant in init.rb!
    # Options:
    #   :locale => [query_option] (e.g. "oe=utf8") -- used to request results in specific format
    def initialize(options = {})
      @api_key = options[:api_key] || GeoX::GOOGLE_API_KEY
      if options[:api_url_base].blank?
        @api_url_base = "http://maps.google.com/maps/geo?"
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
      url = []
      url << @api_url_base
      url << "key=#{@api_key}"
      full_address = ""
      full_address += location[:address]+', '  if !location[:address].blank?
      full_address += location[:city]+', '     if !location[:city].blank?
      full_address += location[:state]+' '    if !location[:state].blank?
      full_address += location[:post_code]+ ' '  if !location[:post_code].blank?
      full_address.strip!
      full_address.chomp!(',')
      url << "q=" + CGI::escape(full_address)
      url << "output=xml"
      url << self.locale if self.locale
      url = url.join("&")
      begin
        response = Hpricot(open(url))
      rescue
        return [GeoX::NetFailure.new]
      end
      # return the array provided by parse location
      parse_locations(response, options)
    end

    # converts address from mapquest compatible intersection format
    def convert_html_safely(string)
      if !self.preserve_html?
        string.gsub!(%r{&amp;}, '&')
      end
      string
    end

    protected

    attr_accessor :preserve_html

    def set_options(options)
      super(options)
      self.preserve_html = !!options[:preserve_html] if options.include?(:preserve_html)
      self.locale = options[:locale] if options[:locale]
    end

    def preserve_html?
      self.preserve_html
    end

    # returns :street, :block, :post_code, :city, :multiple, :unknown
    def parse_locations(response, options = {})
      retval = []
      # we want all <location> tags that are in a <locations> tag alongsinde a status tag:
      # <locations><status>xx</status><location>!!</location></locations>
      # (there are other  <locations> tags that have <location> tags but no <status> tags: we don't want these)
      response.search('//response/placemark').each do |location|
        case location.search('addressdetails').first[:accuracy]
          when '8'
            geocode = GeoX::Street.new
          when '7', '6'
            geocode = GeoX::Block.new
          when '5'
            geocode = GeoX::PostCode.new
          when '4', '3'
            geocode = GeoX::City.new
          else
            geocode = GeoX::Unknown.new
        end # case..
        geocode.address = self.convert_html_safely(location.search('thoroughfarename').inner_html)
        geocode.city = self.convert_html_safely(location.search('localityname').inner_html)
        geocode.county = self.convert_html_safely(location.search('subadministrativeareaname').inner_html)
        geocode.state = self.convert_html_safely(location.search('administrativeareaname').inner_html)
        geocode.country = self.convert_html_safely(location.search('countrynamecode').inner_html)
        geocode.post_code = self.convert_html_safely(location.search('postalcodenumber').inner_html)
        # example Google coordinate values
        #-122.083739,37.423021,0
        raw_coords = location.search('coordinates').inner_html
        coords = self.parse_google_coordinates(raw_coords)
        geocode.longitude = coords[:longitude]
        geocode.latitude = coords[:latitude]
        retval << geocode
      end # response.search...
      remove_duplicate_geocodes(retval) if self.remove_duplicates?
      retval
    end #generate_location

    def parse_google_coordinates(coordinates)
      retval = {}
      if !coordinates.blank?
        cols = coordinates.split(',')
        retval[:longitude] = cols[0] if !cols[0].blank?
        retval[:latitude] = cols[1] if !cols[1].blank?
      end
      retval
    end

    # Google API Request parameters
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

    # Google Accuracy codes:
    #Constants   Description
    #0   Unknown location. (Since 2.59)
    #1   Country level accuracy. (Since 2.59)
    #2   Region (state, province, prefecture, etc.) level accuracy. (Since 2.59)
    #3   Sub-region (county, municipality, etc.) level accuracy. (Since 2.59)
    #4   Town (city, village) level accuracy. (Since 2.59)
    #5   Post code (zip code) level accuracy. (Since 2.59)
    #6   Street level accuracy. (Since 2.59)
    #7   Intersection level accuracy. (Since 2.59)
    #8   Address level accuracy. (Since 2.59)
  end
end # GeoX