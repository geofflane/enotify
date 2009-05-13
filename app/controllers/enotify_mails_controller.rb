class EnotifyMailsController < ApplicationController
  layout 'default'
  permit "admin", :only => [:new, :edit, :create, :update, :destroy]
  
  @@router = EnotifyRouter.new('Milwaukee', 'WI')
   
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
      format.js do
        render :update do |page|
          page.replace_html 'enotify_popup', :partial => 'enotify_body', :object => @enotify_mail
          page << "$('enotify_popup').popup.show();"
        end
      end
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

  # POST /enotify_mails
  # POST /enotify_mails.xml
  def create    
    @report = @@router.create_from_raw_mail(params[:enotify_mail][:original_text])
    @enotify_mail = @report.enotify_mail
    
    respond_to do |format|
      if @report.save
        flash[:notice] = 'EnotifyMail was successfully created.'
        format.html { redirect_to(@enotify_mail) }
        format.xml  { render :xml => @enotify_mail, :status => :created, :location => @enotify_mail }
      else
        format.html { render :action => "new" }
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
