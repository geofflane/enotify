class ServiceRequestsController < ApplicationController
  layout 'default'
  
  # GET /service_requests
  # GET /service_requests.xml
  def index
    if (params[:month] && params[:year])
      @service_requests = ServiceRequest.find_by_month_and_year(params[:month], params[:year])
    else
      @service_requests = ServiceRequest.find(:all)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_requests }
    end
  end

  # GET /service_requests/1
  # GET /service_requests/1.xml
  def show
    @service_request = ServiceRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_request }
    end
  end

  # GET /service_requests/new
  # GET /service_requests/new.xml
  def new
    @service_request = ServiceRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_request }
    end
  end

  # GET /service_requests/1/edit
  def edit
    @service_request = ServiceRequest.find(params[:id])
  end

  # POST /service_requests
  # POST /service_requests.xml
  def create
    @service_request = ServiceRequest.new(params[:service_request])

    respond_to do |format|
      if @service_request.save
        flash[:notice] = 'ServiceRequest was successfully created.'
        format.html { redirect_to(@service_request) }
        format.xml  { render :xml => @service_request, :status => :created, :location => @service_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /service_requests/1
  # PUT /service_requests/1.xml
  def update
    @service_request = ServiceRequest.find(params[:id])

    respond_to do |format|
      if @service_request.update_attributes(params[:service_request])
        flash[:notice] = 'ServiceRequest was successfully updated.'
        format.html { redirect_to(@service_request) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_requests/1
  # DELETE /service_requests/1.xml
  def destroy
    @service_request = ServiceRequest.find(params[:id])
    @service_request.destroy

    respond_to do |format|
      format.html { redirect_to(service_requests_url) }
      format.xml  { head :ok }
    end
  end
end
