class IncidentParser
  INCIDENT_REGEX=/\((#[\d]+)\) of (.*) was recorded at (.*) on (.*) @ (.*)/
  RESOLUTION_REGEX=/was recorded as (.*)\./
  
  def parse(text, city, state) 
    incident = Incident.new
    address = Address.new
    address.city = city
    address.state = state
    
    incident.report_number, incident.description, address.street1, date, t = INCIDENT_REGEX.match(text).captures
    incident.address = address   # frozen once it's assigned - weird composed_of behavior, not sure if I like it
    incident.resolution = RESOLUTION_REGEX.match(text).captures[0]
    incident.time = Time.parse(date + ' ' + t)

    incident
  end

end
