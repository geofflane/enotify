class Enotify < ActionMailer::Base
  
  @@reports = CityReports.new(IncidentParser.new, GeoLocationLookup.new, 'Milwaukee', 'WI')
  
  def receive(email)
    enotify_mail = EnotifyMail.new
    enotify_mail.full_text = email.body
    enotify_mail.title = email.subject
        
    # remove any HTML tags and random sets of blank spaces
    cleaned_body = email.body.gsub(/<[^>]*(>+|\s*\z)/m,'').gsub("&nbsp;", '').split(" ").join(" ")
    
    begin
      enotify_mail.incident = @@reports.build_report(cleaned_body)
      enotify_mail.success = true
    rescue Exception => ex
      enotify_mail.success = false
      enotify_mail.parse_error = ex
    end
    enotify_mail.save()

  end
end
