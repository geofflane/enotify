class CrimeParser
  CRIME_REGEX=/\((#[\d]+)\) of (.*) was recorded at (.*) on (.*) @ (.*)/
  RESOLUTION_REGEX=/was recorded as (.+)\. If you/
  
  def parse(text, city, state) 
    crime = Crime.new
        
    crime.record_number, crime.description, street, date, t = CRIME_REGEX.match(text).captures
    crime.address = Address.find_or_create_by_street_and_city_and_state(street, city, state)
    
    crime.resolution = RESOLUTION_REGEX.match(text).captures[0]
    crime.incident_time = Time.parse(date + ' ' + t)

    crime
  end

end
