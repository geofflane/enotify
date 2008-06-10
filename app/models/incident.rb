class Incident < ActiveRecord::Base
  acts_as_temporal
  acts_as_locatable
  
  belongs_to :enotify_mail
  belongs_to :address
  belongs_to :geo_location
  
  # report_number, description, time
end
