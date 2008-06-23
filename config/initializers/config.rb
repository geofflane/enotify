IMAP_SERVER = {
  :host => 'mail.zorched.net',
  :port => 993,
  :use_ssl => true,
  :username => 'deconstructor',
  :password => 'ro3yahYi'
}.freeze

class Date
  def beginning_and_end_of_month
    [beginning_of_month.yesterday.end_of_day, end_of_month.end_of_day]
  end
end

# First, specify the Host that we will be using later for user_notifier.rb
HOST = 'http://enotify.zorched.net'

# Third, add your SMTP settings
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "mail.zorched.net",
  :port => 25,
  :domain => "mail.zorched.net",
  :user_name => "enotify",
  :password => "nor456",
  :authentication => :login
}

Time::DATE_FORMATS[:simple] = "%A %b %d, %Y %H:%M"