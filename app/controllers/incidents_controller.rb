# Milwaukee Enotify Deconstructed
# Copyright (C) 2009 Geoff Lane <geoff@zorched.net>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class IncidentsController < ApplicationController
  include IncidentsHelper
  layout 'default'
  permit "admin", :only => [:new, :edit, :create, :update, :destroy]
  
  # GET /incidents
  # GET /incidents.xml
  def index
    if (params[:month] && params[:year])
      objects = instance_variable_set("@#{controller_name}", current_model.in_month(params[:month], params[:year]).paginate(:page => params[:page], :order => 'incident_time DESC'))
    else
      objects = instance_variable_set("@#{controller_name}", current_model.paginate(:page => params[:page], :order => 'incident_time DESC', :include => [:address, :geo_location]))
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.atom
      format.xml  { render :xml => objects }
      format.ics { render :text => build_calendar(objects).to_ical }
      format.kml { render :text => build_kml(objects) }
    end
  end

  # GET /incidents/recent
  # GET /incidents/recent.xml
  def recent
    objects = instance_variable_set("@#{controller_name}", current_model.recent.paginate(:page => params[:page], :order => 'incident_time DESC'))

    respond_to do |format|
      format.html { render :action => "index" }
      format.atom { render :action => "index" }
      format.xml  { render :xml => objects }
      format.ics { render :text => build_calendar(objects).to_ical }
      format.kml { render :text => build_kml(objects) }
    end
  end
  
  # GET /incidents/search/theft
  # GET /incidents/search/theft.xml
  def search
    terms = params[:terms].split('+').collect{|t| "*#{t}*"}.join(" OR ")
    objects = instance_variable_set("@#{controller_name}", current_model.find_by_contents(terms).paginate(:page => params[:page], :order => 'incident_time DESC'))

    respond_to do |format|
      format.html { render :action => "index" }
      format.atom { render :action => "index" }
      format.xml  { render :xml => objects }
      format.kml { render :text => build_kml(objects) }
    end
  end
  
  # GET /incidents/by_address/1
  # GET /incidents/by_address/1.xml
  def by_address
    objects = instance_variable_set("@#{controller_name}", current_model.by_address_id(params[:address_id]).paginate(:page => params[:page], :order => 'incident_time DESC'))

    respond_to do |format|
      format.html { render :action => "index" }
      format.atom { render :action => "index" }
      format.xml  { render :xml => objects }
      format.kml { render :text => build_kml(objects) }
    end
  end
  
  # GET /incidents/same_block/1
  # GET /incidents/same_block/1.xml
  def same_block
    address = Address.find(params[:address_id])
    objects = instance_variable_set("@#{controller_name}", current_model.same_block(address).paginate(:page => params[:page], :order => 'incident_time DESC'))

    respond_to do |format|
      format.html { render :action => "index" }
      format.atom { render :action => "index" }
      format.xml  { render :xml => objects }
      format.kml { render :text => build_kml(objects) }
    end
  end
  
  # GET /incidents/by_address/1
  # GET /incidents/by_address/1.xml
  def by_record
    objects = instance_variable_set("@#{controller_name}", current_model.by_record_number(params[:record_number]).paginate(:page => params[:page], :order => 'incident_time DESC'))

    respond_to do |format|
      format.html { render :action => "index" }
      format.atom { render :action => "index" }
      format.xml  { render :xml => objects }
      format.kml { render :text => build_kml(objects) }
    end
  end
  
  # GET /incidents/by_date/2008
  # GET /incidents/by_date/2008.xml
  def by_date
    if (params[:month] && params[:year])
      objects = instance_variable_set("@#{controller_name}", current_model.in_month(params[:month], params[:year]).paginate(:page => params[:page], :order => 'incident_time DESC'))
    elsif (params[:year])
      objects = instance_variable_set("@#{controller_name}", current_model.in_year(params[:year]).paginate(:page => params[:page], :order => 'incident_time DESC'))
    end
    respond_to do |format|
      format.html { render :action => "index" }
      format.atom { render :action => "index" }
      format.xml  { render :xml => objects }
      format.kml { render :text => build_kml(objects) }
    end
  end

  # GET /incidents/1
  # GET /incidents/1.xml
  def show
    object = instance_variable_set("@#{controller_name.singularize}", current_model.find(params[:id]))

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => object }
      format.kml { render :text => object.to_kml}
      format.js do
        render :update do |page|
          page.replace_html 'streetview', :partial => 'streetview', :object => object
          page << "$('streetview').popup.show();"
        end
      end
    end
  end

  # GET /incidents/new
  # GET /incidents/new.xml
  def new
    object = instance_variable_set("@#{controller_name.singularize}", current_model.new)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => object }
    end
  end

  # GET /incidents/1/edit
  def edit
    instance_variable_set("@#{controller_name.singularize}", current_model.find(params[:id])) 
  end

  # POST /incidents
  # POST /incidents.xml
  def create
    object = instance_variable_set("@#{controller_name.singularize}", current_model.create(params_hash))

    respond_to do |format|
      if object.save
        flash[:notice] = ' was successfully created.'
        format.html { redirect_to(object) }
        format.xml  { render :xml => object, :status => :created, :location => object }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => object.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /incidents/1
  # PUT /incidents/1.xml
  def update
    object = instance_variable_set("@#{controller_name.singularize}", current_model.find(params[:id])) 

    respond_to do |format|
      if eval("@#{controller_name.singularize}").update_attributes(params_hash)
        flash[:notice] = ' was successfully updated.'
        format.html { redirect_to(object) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => object.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /incidents/1
  # DELETE /incidents/1.xml
  def destroy
    current_model.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to :action=>:index }
      format.xml  { head :ok }
    end
  end

  private 
  def params_hash
    params[controller_name.singularize.to_sym]
  end
  
  def build_kml(incidents)
    xm = Builder::XmlMarkup.new
    xm.instruct!
    xm.kml("xmlns"=>"http://earth.google.com/kml/2.2") {
      xm.Document {
        incidents.each { |i| i.build_kml_body(xm) }
      }
    }
  end

  def build_calendar(incidents)
    cal = Icalendar::Calendar.new
    cal.custom_property("METHOD","PUBLISH")    # Outlook hack?
    incidents.each { |i| cal.add_event(i.to_ical) }
    cal 
  end

end
