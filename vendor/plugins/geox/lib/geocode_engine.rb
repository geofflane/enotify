module GeoX
  # This is a generic stub/abstract class - it should not be instantiated
  # It serves as a template to guide you if you want to build more geocoding engines
  # It also provides same basic functionality/utilities across all engines (like removing duplicates)
  class GeocodeEngine
    # remove_duplicates => true causes engine prevent multiple identical lat/long results
    #  from being returned (MapQuest will sometimes return multiple options that have identical lat/long
    #  coordinates, which is pretty useless for many applications)
    def initialize(options, apikey)
      self.set_options(options)
    end

    # geocode engine should return an array of subclassed instances of GeoX::Geocode
    # in the event of a network failure it should return [GeoX::NetFailure.new]
    # other failure errors should return [GeoX::Failure.new]
    # the instances of GeoX::Geocode should set ".geo_source" to be their own class so
    # callers can know which geoengine provided the geocode
    def geocode(location, options = {})
    end

    def set_options(options)
      self.remove_duplicates = !!options[:remove_duplicates] if options.include?(:remove_duplicates)
    end

    def remove_duplicates?
      self.remove_duplicates
    end

    protected
    attr_accessor :remove_duplicates

    # this routine will remove geocode records from an array where
    # a previous entry in the array already has the same exact lat/long coordinates
    # some engines seem to have the nasty habit of returning duplicate answers sometimes which is unfortunate
    # this routine ensures you only get a single geocode returned for any unique lat/long coordinate (makes sense for most applications)
    def remove_duplicate_geocodes(locations)
      # the code below looks a little funny: we store the latitude as a key and the longitude as the value in a hash
      # so if we encounter a record later that has the same key (i.e. same latitude) we can look at the value (i.e longitude)
      # and see if it matches too. But at first glance it looks like we're comparing latitudes against longitudes which we're not!
      lat_longs = {}
      locations.delete_if do |location|
        if lat_longs[location.latitude] == location.longitude
          true
        else
          lat_longs[location.latitude] = location.longitude
          false
        end
      end
    end
  end #class GeocodeEngine
end # module GeoX