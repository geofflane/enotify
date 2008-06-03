class EnotifyMail < ActiveRecord::Base
  has_one :incident

  # full_text, title, success
end
