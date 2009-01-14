require 'hpricot'
require 'hpricot/xchar'
Hpricot::XChar::PREDEFINED_U.merge!({"&nbsp;" => 32})

module TMail
  class Mail
    # remove any HTML tags and random sets of blank spaces
    def clean_body
      doc = Hpricot.parse(body.gsub("><", ">\n<"), :xhtml_strict => true)
      doc.inner_text.split(' ').join(' ')
    end
  end
end

class EnotifyRouter
  
  def initialize(city, state)
    gl = GeoLocationLookup.new
    @crime_reports = CityReports.new(CrimeParser.new, gl, city, state)
    @permit_reports = CityReports.new(PermitRecordParser.new, gl, city, state)
    @service_reports = CityReports.new(ServiceRequestParser.new, gl, city, state)
    @recording_reports = CityReports.new(RecordingAppParser.new, gl, city, state)
    @violation_reports = CityReports.new(ViolationRecordParser.new, gl, city, state)
  end
  
  # original_text, clean_text, title, success
  
  def create_from_raw_mail(raw_mail)
    email = TMail::Mail.parse(raw_mail)
    create_from_mail(email)
  end
  
  def create_from_mail(email)
    report_builder = report_builder_for_mail(email)
    cleaned_body = email.clean_body

    begin
      report = report_builder.build_report(cleaned_body)
      report.enotify_mail = EnotifyMail.new(:original_text => email.body, :clean_text => cleaned_body, :title => email.subject) if report
    rescue Exception => ex
      Rails.logger.error(cleaned_body)
      enotify_mail.set_error(ex)
      Rails.logger.error(ex)
    end
    
    report
  end
  
  def report_builder_for_mail(email)
    if email.subject =~ /new service request/
      return @service_reports
    elsif email.subject =~ /new permit record/
      return @permit_reports
    elsif email.subject =~ /new recording application/
      return @recording_reports
    elsif email.subject =~ /new violation record/
      return @violation_reports
    elsif email.subject =~ /Crime Incident/
      return @crime_reports
    else
      raise Exception.new, "Unknown enotify"
    end
  end
end
