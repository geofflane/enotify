
class UsersController < ApplicationController
  layout 'sessions'
  
  # Protect these actions behind an admin login
  permit "admin", :except => [:new, :create, :activate]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]

  # GET /users
  def index
    # @users = User.find(:all, :limit => 25, :order => "created_at DESC")
    @users = User.paginate(:page => params[:page], :order => 'created_at DESC')
  end

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.register! if @user.valid?
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up! An activation email has been sent."
    else
      render :action => 'new'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

protected
  def find_user
    @user = User.find(params[:id])
  end

end
