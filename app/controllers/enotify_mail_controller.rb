class EnotifyMailController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @enotify_mails_pages, @enotify_mails = paginate :enotify_mails, :per_page => 10
  end

  def show
    @enotify_mail = EnotifyMail.find(params[:id])
  end

  def new
    @enotify_mail = EnotifyMail.new
  end

  def create
    @enotify_mail = EnotifyMail.new(params[:enotify_mails])
    if @enotify_mail.save
      flash[:notice] = 'Enotify Mail was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @enotify_mail = EnotifyMail.find(params[:id])
  end

  def update
    @enotify_mail = EnotifyMail.find(params[:id])
    if @enotify_mail.update_attributes(params[:enotify_mail])
      flash[:notice] = 'Enotify Mail was successfully updated.'
      redirect_to :action => 'show', :id => @enotify_mail
    else
      render :action => 'edit'
    end
  end

  def destroy
    EnotifyMail.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

end
