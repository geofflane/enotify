class Incident < ActiveRecord::Base
  validates_uniqueness_of :record_number
  validates_presence_of :record_number
  
  acts_as_temporal
  acts_as_locatable
  
  belongs_to :enotify_mail
  belongs_to :address
  belongs_to :geo_location
  
  # record_number, description, tax_key, time
end
