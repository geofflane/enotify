class Incident < ActiveRecord::Base
  belongs_to :enotify_mail
  composed_of :address, :mapping => [ %w(address_street1 street1), %w(address_street2 street2), %w(address_city city),
                                   %w(address_state state), %w(address_zip zip) ]
  composed_of :geo_location, :mapping => [ %w(geo_location_long long), %w(geo_location_lat lat) ]
  # report_number, description, time

end
