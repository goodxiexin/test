class Profile::ProfilesController < ApplicationController

  layout 'app2'

  before_filter :login_required, :setup

	after_filter :record_visiting, :only => [:show]

  before_filter :privilege_required, :only => [:show, :more_feeds]

	before_filter :owner_required, :only => [:update]

	FirstFetchSize = 2

	FetchSize = 2

  def show
		@comments = @profile.comments.paginate :page => params[:page], :per_page => 10
    @tagging = @profile.taggings.find_by_poster_id(current_user.id)
		@taggable = @user.friends.include?(current_user) && (@tagging.nil? || @tagging.created_at < 1.week.ago)
		@blogs = @user.blogs[0..2]
		@albums = @user.albums.viewable(relationship).push(@user.avatar_album)[0..2]
		@feed_deliveries = @profile.feed_deliveries.find(:all, :limit => FirstFetchSize)
	end

  def edit
    case params[:type].to_i
    when 0
			render :action => 'edit', :layout => 'app'
		when 1
      render :partial => 'edit_basic_info'
    when 2
      render :partial => 'edit_contact_info'
    end
  end

  def update
    if @profile.update_attributes(params[:profile])
			respond_to do |format|
				format.json { render :json => @profile }
				format.html {
					case params[:type].to_i
					when 1
					  render :partial => 'basic_info'
					when 2
					  render :partial => 'contact_info'
					end
				}
			end
    end
  end

	def more_feeds
		@feed_deliveries = @profile.feed_deliveries.find(:all, :offset => FirstFetchSize + FetchSize * params[:idx].to_i, :limit => FetchSize)
	end

protected

  def setup
		if ["more_feeds", "show"].include? params[:action]
			@profile = Profile.find(params[:id])
			@user = @profile.user
			@setting = @user.privacy_setting
			@privilege = @setting.personal
			@reply_to = User.find(params[:reply_to]) if params[:reply_to]
		elsif ["edit", "update"].include? params[:action]
			@profile = Profile.find(params[:id])
			@user = @profile.user
		end
  rescue
    not_found
  end

	def record_visiting
		return if current_user == @user
		record = @profile.visitor_records.find_by_visitor_id(current_user.id)
		if record.nil? # create a new one
			if @profile.visitor_records.count >= Profile::MAX_VISITOR_RECORDS
				@profile.visitor_records.last.destroy
			end
			@profile.visitor_records.create(:visitor_id => current_user.id)
		else # update old one
			record.update_attribute('created_at', Time.now)
		end
	end

end
