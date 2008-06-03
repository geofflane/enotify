# SimpleGeocoder
require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'cgi'

# geox files
# edit geox_api_keys to put your mapquest/google/yahoo api keys here
# this file can be located here or in the rails config folder

config_api_keys_path = File.expand_path(File.dirname(__FILE__) + "/../../../../config/geox_api_keys.rb")
if File::exists?(config_api_keys_path)
  require config_api_keys_path
else
  require 'geox_api_keys'
end
require 'geocode_engine'
require 'mapquest'
require 'yahoo'
require 'google'
require 'fail_engine' # for simulating network failures during geocode

module GeoX
  # to permit numeric version checking
  MAJOR_VER, MINOR_VER, RELEASE_VER = 0,2,0
  VERSION = "#{MAJOR_VER}.#{MINOR_VER}.#{RELEASE_VER}" # e.g. "0.1.1"
  # version history
  # "0.1.0" - initial release
  # "0.1.1" - added support for remembering prior intersection names in mapquest
  # "0.2.0" - added support for geocoding failover and locating api_keys in rails config folder

  class GeoError < StandardError; end
  class GeoErrorParameter < GeoError; end
  class GeoErrorAccuracy < GeoError; end
  class GeoErrorGeoFailure < GeoError; end

  class Generic; end

  # geo_engine parameter for initialize option hash must support "geocode(location_hash, options_hash)" method and
  # that method must return an array with one or more Geocode instances in it,
  # representing the one or more geocode locations that were coded from source input
  class Geocoder < GeoX::Generic
    def initialize(options = {})
      # default engine in MapQuest
      geocode_klass = options[:geoengine] || GeoX::MapQuest
      # if we are passed an array of engines, we instantiate them all and fallback on them as necessary
      if geocode_klass.kind_of?(Array)
        @geo_engines = geocode_klass.collect {|gk| gk.new(options)}
      else
        @geo_engines = [geocode_klass.new(options)]
      end
      @geo_klass = geocode_klass
    end

    def geocode(location, options = {})
      # loop through each engine, and stop if no results are returned or if successful geocode is obtained (or if we run out of geocoders to try)
      retval = nil
      @geo_engines.each do |geo_engine|
        retval = geo_engine.geocode(location, options)
        if retval.blank? : break; end
        if retval[0].success? : break; end
      end
      retval
    end
  end # class Geocoder..

  # Geocode "types" (classes)
  # returned by geocoder
  class Geocode < GeoX::Generic
    include Comparable

    # warnings are user displayable text (or maybe html) messages about the geocode
    attr_accessor :address,:city,:state,:county,:post_code,:country,:latitude,:longitude,:warnings
    # either nil or a class object indicating the source of the geocode (i.e. which engine provided it, if there were multiple provided)
    attr_accessor :geo_source

    def initialize(options = {})
      self.set_location(options) if !options.blank?
    end

    def set_location(location)
      self.address = location[:address]
      self.city = location[:city]
      self.county = location[:county]
      self.state = location[:state]
      self.post_code = location[:post_code]
      self.country = location[:country]
      self.latitude = location[:latitude]
      self.longitude = location[:longitude]
    end
  
    def success?
      true
    end

    def <=>(comparison)
      self.class.<=>(comparison)
    end

    def Geocode.<=>(comparison)
      # we return the class (which is comparable) for whatever object is passed to us
      get_class(comparison)
    end

    protected

    def Geocode.get_class(obj)
      if obj.respond_to?(:ancestors) && obj.ancestors.include?(Geocode)
        retval = obj
      elsif obj.kind_of?(Geocode)
        retval = obj.class
      else
        retval = nil
      end
      retval
    end
  end #class Geocode

  class Street < Geocode
    def Street.<=>(comparison)
      comparison_klass = super(comparison)
      comparison_klass == Street ? 0 : -1
    end
  end #class Street

  class Block < Geocode
    def <=>(comparison)
      comparison_klass = super(comparison)
      case
        when comparison_klass == Street
          retval = +1
        when comparison_klass == Block
          retval = 0
        else
          retval = -1
      end
      retval
    end
  end #class Block

  class PostCode < Geocode
    def <=>(comparison)
      comparison_klass = super(comparison)
      case
        when comparison_klass == Street || comparison_klass == Block
          retval = +1
        when comparison_klass == PostCode
          retval = 0
        else
          retval = -1
      end
      retval
    end
  end #class PostCode

  class City < Geocode
    def <=>(comparison)
      comparison_klass = super(comparison)
      case comparison_klass
        when comparison_klass == Street || comparison_klass == Block || comparison_klass == PostCode
          retval = +1
        when comparison_klass == City
          retval = 0
        else
          retval = -1
      end
      retval
    end
  end #class City

  class Unknown < Geocode
    #Unknown is always "bigger" (more uncertain) than other Geocodes
    def<=>(comparison)
      +1
    end
  end

  # This class instance is returned when the geocode engine cannot obtain a geocode, probably due to network error
  class Failure < Geocode
    # Failure does not compare - it will raise an error, so check for failure before comparing
    def<=>(comparison)
      raise GeoErrorGeoFailure, "Attempted to compare a failed geocode with a real geocode"
    end
    
    def success?
      false
    end
  end

  # subclass of Failure specifically for Network trouble - if you care about that
  class NetFailure < Failure
  end

end # SimpleGeocoder