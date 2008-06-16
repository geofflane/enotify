class PermitRecordParser
  PERMIT_REGEX = /At (.*) \(taxkey # ([\d-]+)\), there is a new permit record ([#\d]+)/
  TYPE_REGEX = /Permit type: (.+) Please click link below/
  
  def parse(text, city, state) 
    permit_record = PermitRecord.new
    
    street, permit_record.tax_key, permit_record.record_number = PERMIT_REGEX.match(text).captures
    permit_record.address = Address.find_or_create_by_street_and_city_and_state(street, city, state)
    
    permit_record.description = TYPE_REGEX.match(text).captures[0]
    permit_record.incident_time = Time.new

    permit_record
  end
  
end
