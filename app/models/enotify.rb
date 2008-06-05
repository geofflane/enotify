class Enotify < ActionMailer::Base

  @@reports = CityReports.new(IncidentParser.new, GeoLocationLookup.new, 'Milwaukee', 'WI')
  
  def receive(email)
    enotify_mail = EnotifyMail.create_from_mail(@@reports, email)
    enotify_mail.save()
  end
end
