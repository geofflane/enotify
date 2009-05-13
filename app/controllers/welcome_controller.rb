class WelcomeController < ApplicationController
  layout 'default'
  
  def index
    @incidents = Incident.recent.find(:all, :limit => 25, :order => "created_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.atom
      format.xml  { render :xml => @incidents }
    end
  end
  
  def search
    url = url_for(:controller=>:incidents, :action=>:search) + "/" + CGI::escape(params[:term])
    redirect_to url
  end
end
