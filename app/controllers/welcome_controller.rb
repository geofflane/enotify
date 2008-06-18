class WelcomeController < ApplicationController
  before_filter :login_required
  layout 'default'
  
  def index
    @incidents = Incident.recent
  end
end
