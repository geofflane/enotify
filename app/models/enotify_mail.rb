class EnotifyMail < ActiveRecord::Base
  has_one :incident
  
  def success
    read_attribute(:success) or true
  end
  
  def inner_html
    doc = Hpricot(original_text)
    body = doc.at('body')
    body = doc if ! body
    body.inner_html
  end
  
  def set_error(ex)
    success = false
    parse_error = ex
  end
end
