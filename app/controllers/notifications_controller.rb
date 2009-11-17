class NotificationsController < ApplicationController

  layout 'app'

  before_filter :login_required

  before_filter :catch_notification, :only => [:destroy]

  def index
    @notifications = current_user.notifications
  end

	def first_five
		@notifications = current_user.notifications.find(:all, :limit => 5)
		render :action => 'first_five', :layout => false
	end

  def destroy
    @notification.destroy
    render :update do |page|
			page << "$('notification_#{@notification.id}').remove();"
		end
  end

protected
        
  def catch_notification
    @notification = current_user.notifications.find(params[:id])
  rescue
    not_found
  end

end
