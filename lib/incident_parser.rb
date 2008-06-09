class IncidentParser
  INCIDENT_REGEX=/\((#[\d]+)\) of (.*) was recorded at (.*) on (.*) @ (.*)/
  RESOLUTION_REGEX=/was recorded as (.+)\. If you/
  
  def parse(text, city, state) 
    incident = Incident.new
        
    incident.report_number, incident.description, street, date, t = INCIDENT_REGEX.match(text).captures
    incident.address = Address.existing_or_new(street, city, state)
    
    incident.resolution = RESOLUTION_REGEX.match(text).captures[0]
    incident.time = Time.parse(date + ' ' + t)

    incident
  end

end
