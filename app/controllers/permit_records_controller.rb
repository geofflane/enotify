class PermitRecordsController < ApplicationController
  before_filter :login_required
  layout 'default'
  
  # GET /permit_records
  # GET /permit_records.xml
  def index
    if (params[:month] && params[:year])
      @permit_records = PermitRecord.find_by_month_and_year(params[:month], params[:year])
    else
      @permit_records = PermitRecord.find(:all)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @permit_records }
    end
  end

  # GET /permit_records/1
  # GET /permit_records/1.xml
  def show
    @permit_record = PermitRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @permit_record }
    end
  end

  # GET /permit_records/new
  # GET /permit_records/new.xml
  def new
    @permit_record = PermitRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @permit_record }
    end
  end

  # GET /permit_records/1/edit
  def edit
    @permit_record = PermitRecord.find(params[:id])
  end

  # POST /permit_records
  # POST /permit_records.xml
  def create
    @permit_record = PermitRecord.new(params[:permit_record])

    respond_to do |format|
      if @permit_record.save
        flash[:notice] = 'PermitRecord was successfully created.'
        format.html { redirect_to(@permit_record) }
        format.xml  { render :xml => @permit_record, :status => :created, :location => @permit_record }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @permit_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /permit_records/1
  # PUT /permit_records/1.xml
  def update
    @permit_record = PermitRecord.find(params[:id])

    respond_to do |format|
      if @permit_record.update_attributes(params[:permit_record])
        flash[:notice] = 'PermitRecord was successfully updated.'
        format.html { redirect_to(@permit_record) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @permit_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /permit_records/1
  # DELETE /permit_records/1.xml
  def destroy
    @permit_record = PermitRecord.find(params[:id])
    @permit_record.destroy

    respond_to do |format|
      format.html { redirect_to(permit_records_url) }
      format.xml  { head :ok }
    end
  end
end
