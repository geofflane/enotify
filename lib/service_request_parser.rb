class ServiceRequestParser
  SERVICE_REGEX = /At (.*) \(taxkey # ([\d-]+)\), there is a new service request record ([#\d]+)/
  COMPLAINT_REGEX = /Complaint description: (.+) Please click link below/
  
  def parse(text, city, state) 
    service_request = ServiceRequest.new
    
    street, service_request.tax_key, service_request.record_number = SERVICE_REGEX.match(text).captures
    service_request.address = Address.existing_or_new(street, city, state)
    
    service_request.description = COMPLAINT_REGEX.match(text).captures[0]
    service_request.time = Time.new

    service_request
  end
  
end