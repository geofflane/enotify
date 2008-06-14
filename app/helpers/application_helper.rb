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
    return unless incidents && incidents.size > 0
    
    total_lat = incidents.inject(0) do |sum, i| sum + i.geo_location.latitude end
    total_long = incidents.inject(0) do |sum, i| sum + i.geo_location.longitude end
    
    avg_lat = total_lat / incidents.size
    avg_long = total_long / incidents.size
    "#{avg_lat}, #{avg_long}"
  end
end
