class EnotifyMail < ActiveRecord::Base
  has_one :incident
end
