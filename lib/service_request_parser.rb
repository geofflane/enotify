class ServiceRequestParser
  SERVICE_REGEX = /At (.*) \(taxkey # ([\d-]+)\), there is a new service request record ([#\d]+)/
  COMPLAINT_REGEX = /Complaint description: (.+) Please click link below/
  
  def parse(text, city, state) 
    service_request = ServiceRequest.new
    service_request.address = Address.new(:city => city, :state => state)
    
    service_request.address.street, service_request.tax_key, service_request.record_number = SERVICE_REGEX.match(text).captures
    service_request.complaint = COMPLAINT_REGEX.match(text).captures[0]
    service_request.time = Time.new

    service_request
  end
  
end