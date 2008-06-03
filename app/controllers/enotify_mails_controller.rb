class EnotifyMailsController < ApplicationController
  # GET /enotify_mails
  # GET /enotify_mails.xml
  def index
    @enotify_mails = EnotifyMail.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @enotify_mails }
    end
  end

  # GET /enotify_mails/1
  # GET /enotify_mails/1.xml
  def show
    @enotify_mail = EnotifyMail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @enotify_mail }
    end
  end

  # GET /enotify_mails/new
  # GET /enotify_mails/new.xml
  def new
    @enotify_mail = EnotifyMail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @enotify_mail }
    end
  end

  # GET /enotify_mails/1/edit
  def edit
    @enotify_mail = EnotifyMail.find(params[:id])
  end

  # POST /enotify_mails
  # POST /enotify_mails.xml
  def create
    @enotify_mail = EnotifyMail.new(params[:enotify_mail])

    respond_to do |format|
      if @enotify_mail.save
        flash[:notice] = 'EnotifyMail was successfully created.'
        format.html { redirect_to(@enotify_mail) }
        format.xml  { render :xml => @enotify_mail, :status => :created, :location => @enotify_mail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @enotify_mail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /enotify_mails/1
  # PUT /enotify_mails/1.xml
  def update
    @enotify_mail = EnotifyMail.find(params[:id])

    respond_to do |format|
      if @enotify_mail.update_attributes(params[:enotify_mail])
        flash[:notice] = 'EnotifyMail was successfully updated.'
        format.html { redirect_to(@enotify_mail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @enotify_mail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /enotify_mails/1
  # DELETE /enotify_mails/1.xml
  def destroy
    @enotify_mail = EnotifyMail.find(params[:id])
    @enotify_mail.destroy

    respond_to do |format|
      format.html { redirect_to(enotify_mails_url) }
      format.xml  { head :ok }
    end
  end
end
