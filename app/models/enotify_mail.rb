class EnotifyMail < ActiveRecord::Base
  has_one :incident
  
  def inner_html
    doc = Hpricot(original_text)
    body = doc.at('body')
    body = doc if ! body
    body.inner_html
  end
end
