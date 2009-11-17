class UsersController < ApplicationController

	caches_page :new

  def new
    @user = User.new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    if User.find_by_email(params[:user][:email])
			render :update do |page|
				page << "$('email_info').innerHTML = '被占用';"
			end
			return
		end
    @user = User.new(params[:user])
    @user.save!
    params[:cs].each do |args|
      @user.game_characters.create(args)
    end unless params[:cs].blank?
    flash[:notice] = "Thanks for signing up! Please check your email to activate your account before you log in"
    render :update do |page|
      page.redirect_to '/login'
    end
  rescue ActiveRecord::RecordInvalid
    flash.now[:notice] = "There was a problem creating your account"
    render :action => 'new'
  end

  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user"
    end
    redirect_to :action => 'index'
  end

  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user"
    end
    redirect_to :action => 'index'
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end

end
