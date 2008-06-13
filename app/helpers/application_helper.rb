# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def center_geo_locations(incidents)
    total_lat = incidents.inject(0) do |sum, i| sum + i.geo_location.latitude end
    total_long = incidents.inject(0) do |sum, i| sum + i.geo_location.longitude end
    
    avg_lat = total_lat / incidents.size
    avg_long = total_long / incidents.size
    "#{avg_lat}, #{avg_long}"
  end
end
