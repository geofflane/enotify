# Methods added to this helper will be available to all templates in the application.
config_api_keys_path = File.expand_path(File.dirname(__FILE__) + "/../../config/geox_api_keys.rb")

if File::exists?(config_api_keys_path)
  require config_api_keys_path
end
  
module ApplicationHelper

  def google_api_key() 
    GeoX::GOOGLE_API_KEY
  end
  
  def center_geo_locations(incidents)
    return unless incidents
    "#{avg_lat(incidents)}, #{avg_long(incidents)}"
  end
  
  def avg_lat(incidents)
    return 0 unless incidents
    total_lat(incidents) / incidents.size
  end
  
  def avg_long(incidents)
    return 0 unless incidents
    total_long(incidents) / incidents.size
  end
  
  def total_lat(incidents)
    return 0 unless incidents
    incidents.inject(0) do |sum, i| sum + i.geo_location.latitude end
  end
  
  def total_long(incidents)
    return 0 unless incidents
    incidents.inject(0) do |sum, i| sum + i.geo_location.longitude end
  end
  
  def user_has_role(role, &block)
    if logged_in? && current_user.has_role?(role) 
      if block_given?
        yield
      else
        return true
      end
    end
    false
  end
  
end
