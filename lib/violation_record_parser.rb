class ViolationRecordParser
  VIOLATION_REGEX = /At (.*) \(taxkey # ([\d-]+)\)/
  SERIAL_REGEX = /Serial number ([#\d]+) (.+) Please click/


  def parse(text, city, state) 
    violation_record = ViolationRecord.new

    street, violation_record.tax_key = VIOLATION_REGEX.match(text).captures
    violation_record.record_number, violation_record.description = SERIAL_REGEX.match(text).captures
    violation_record.address = Address.find_or_create_by_street_and_city_and_state(street, city, state)

    violation_record.incident_time = Time.new

    violation_record
  end
  
end
