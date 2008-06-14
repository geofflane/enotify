class WelcomeController < ApplicationController
  before_filter :login_required
  layout 'default'
  
  def index
    now = Time.now
    @incidents = Incident.find_by_month_and_year(now.month, now.year)
  end
end
