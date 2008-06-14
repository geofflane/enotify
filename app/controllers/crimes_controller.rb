class CrimesController < ApplicationController
  before_filter :login_required
  layout 'default'
  
  # GET /crimes
  # GET /crimes.xml
  def index
    if (params[:month] && params[:year])
      @crimes = Crime.find_by_month_and_year(params[:month], params[:year])
    else
      @crimes = Crime.find(:all)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.atom
      format.xml  { render :xml => @crimes }
    end
  end

  # GET /crimes/1
  # GET /crimes/1.xml
  def show
    @crime = Crime.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @crime }
    end
  end

  # GET /crimes/new
  # GET /crimes/new.xml
  def new
    @crime = Crime.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @crime }
    end
  end

  # GET /crimes/1/edit
  def edit
    @crime = Crime.find(params[:id])
  end

  # POST /crimes
  # POST /crimes.xml
  def create
    @crime = Crime.new(params[:crime])

    respond_to do |format|
      if @crime.save
        flash[:notice] = 'Crime was successfully created.'
        format.html { redirect_to(@crime) }
        format.xml  { render :xml => @crime, :status => :created, :location => @crime }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @crime.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /crimes/1
  # PUT /crimes/1.xml
  def update
    @crime = Crime.find(params[:id])

    respond_to do |format|
      if @crime.update_attributes(params[:crime])
        flash[:notice] = 'Crime was successfully updated.'
        format.html { redirect_to(@crime) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @crime.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /crimes/1
  # DELETE /crimes/1.xml
  def destroy
    @crime = Crime.find(params[:id])
    @crime.destroy

    respond_to do |format|
      format.html { redirect_to(crimes_url) }
      format.xml  { head :ok }
    end
  end
end
