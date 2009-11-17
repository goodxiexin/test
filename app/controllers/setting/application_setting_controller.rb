class Setting::ApplicationSettingController < ApplicationController

	layout 'app'

	before_filter :login_required, :setup

	def show
	end

	def edit
		case params[:type].to_i 
		when 0
			render :action => 'blog_config', :layout => false
		when 1
			render :action => 'video_config', :layout => false
		when 2
			render :action => 'photo_config', :layout => false
		when 3
			render :action => 'poll_config', :layout => false
		when 4
			render :action => 'event_config', :layout => false
		when 5
			render :action => 'guild_config', :layout => false
		end	
	end

	def update
		if @setting.update_attributes(params[:setting])
			render :update do |page|
				page << "facebox.close();"
			end
		end	
	end

protected

	def setup
		@setting = current_user.application_setting	
	end

end
