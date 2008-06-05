class Incident < ActiveRecord::Base
  belongs_to :enotify_mail
  belongs_to :address
  belongs_to :geo_location

  # report_number, description, time
end
