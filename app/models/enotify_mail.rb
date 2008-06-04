class EnotifyMail < ActiveRecord::Base
  has_one :incident

  # full_text, title, success
  def self.create_from_raw_mail(report_builder, raw_mail)
    email = TMail::Mail.parse(raw_mail)
    self.create_from_mail(report_builder, email)
  end
  
  def self.create_from_mail(report_builder, email)
    enotify_mail = EnotifyMail.new
    enotify_mail.full_text = email.body
    enotify_mail.title = email.subject
        
    # remove any HTML tags and random sets of blank spaces
    cleaned_body = email.body.gsub(/<[^>]*(>+|\s*\z)/m,'').gsub("&nbsp;", '').split(" ").join(" ")
    
    begin
      enotify_mail.incident = report_builder.build_report(cleaned_body)
      enotify_mail.success = true
    rescue Exception => ex
      enotify_mail.success = false
      enotify_mail.parse_error = ex
    end
    enotify_mail
  end
end
