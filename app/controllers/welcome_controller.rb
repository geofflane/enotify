class WelcomeController < ApplicationController
  layout 'default'
  before_filter :login_required
  
  def index
    @incidents = Incident.recent.find(:all, :limit => 25, :order => "created_at DESC")
  end
  
  def search
    url = url_for(:controller=>:incidents, :action=>:search) + "/" + CGI::escape(params[:term])
    redirect_to url
  end
end
