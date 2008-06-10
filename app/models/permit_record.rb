class PermitRecord < ActiveRecord::Base
  acts_as_temporal
  acts_as_locatable
    
  belongs_to :enotify_mail
  belongs_to :address
  belongs_to :geo_location
  
  # tax_key, record_number, description, time
end
