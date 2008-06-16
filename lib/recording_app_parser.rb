class RecordingAppParser
  RECORDING_REGEX = /At (.*) \(taxkey # ([\d-]+)\), there is a new recording application ([#\d]+)/
  
  def parse(text, city, state) 
    recording_app = RecordingApplication.new
    
    street, recording_app.tax_key, recording_app.record_number = RECORDING_REGEX.match(text).captures
    recording_app.address = Address.find_or_create_by_street_and_city_and_state(street, city, state)

    recording_app.incident_time = Time.new

    recording_app
  end
  
end
