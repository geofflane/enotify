class PermitRecord < ActiveRecord::Base
  belongs_to :enotify_mail
  composed_of :address, :mapping => [ %w(address_street street), %w(address_city city),
                                   %w(address_state state), %w(address_zip zip) ]
  composed_of :geo_location, :mapping => [ %w(geo_location_long long), %w(geo_location_lat lat) ]
end
