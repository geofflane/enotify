class EnotifyRouter
  
  def initialize(city, state)
    @incident_reports = CityReports.new(IncidentParser.new, GeoLocationLookup.new, city, state)
    @permit_reports = CityReports.new(PermitRecordParser.new, GeoLocationLookup.new, city, state)
    @service_reports = CityReports.new(ServiceRequestParser.new, GeoLocationLookup.new, city, state)
  end
  
  # full_text, title, success
  def create_from_raw_mail(raw_mail)
    email = TMail::Mail.parse(raw_mail)
    create_from_mail(email)
  end
  
  def create_from_mail(email)
    report_builder = report_builder_for_mail(email)
        
    enotify_mail = EnotifyMail.new(:full_text => email.body, :title => email.subject)
        
    # remove any HTML tags and random sets of blank spaces
    cleaned_body = email.body.gsub(/<[^>]*(>+|\s*\z)/m,'').gsub("&nbsp;", '').split(" ").join(" ")
    
    begin
      report = report_builder.build_report(cleaned_body)
      enotify_mail.success = true
    rescue Exception => ex
      enotify_mail.success = false
      enotify_mail.parse_error = ex
    end
    report.enotify_mail = enotify_mail
    report
  end
  
  def report_builder_for_mail(email)
    if email.subject =~ /new service request/
      return @service_reports
    elsif email.subject =~ /new permit record/
      return @permit_reports
    elsif email.subject =~ /Crime Incident/
      return @incident_reports
    else
      raise Exception.new, "Unknown enotify"
    end
  end
end