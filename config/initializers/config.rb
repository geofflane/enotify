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
