class IncidentsController < ApplicationController
  layout 'default'
  
  # GET /incidents
  # GET /incidents.xml
  def index
    if (params[:month] && params[:year])
      @incidents = Incident.find_by_month_and_year(params[:month], params[:year])
    else
      @incidents = Incident.find(:all)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.atom
      format.xml  { render :xml => @incidents }
    end
  end

  # GET /incidents/1
  # GET /incidents/1.xml
  def show
    @incident = Incident.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @incident }
    end
  end
end
