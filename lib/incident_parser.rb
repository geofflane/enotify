class IncidentParser
  INCIDENT_REGEX=/\((#[\d]+)\) of (.*) was recorded at (.*) on (.*) @ (.*)/
  RESOLUTION_REGEX=/was recorded as (.+)\. If you/
  
  def parse(text, city, state) 
    incident = Incident.new
    incident.address = Address.new(:city => city, :state => state)
    
    incident.report_number, incident.description, incident.address.street, date, t = INCIDENT_REGEX.match(text).captures
    incident.resolution = RESOLUTION_REGEX.match(text).captures[0]
    incident.time = Time.parse(date + ' ' + t)

    incident
  end

end
