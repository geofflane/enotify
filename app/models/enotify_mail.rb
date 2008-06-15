class EnotifyMail < ActiveRecord::Base
  has_one :incident
  
  def inner_html
    doc = Hpricot(original_text)
    doc.at('body').inner_html
  end
end
