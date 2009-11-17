class HomeController < ApplicationController

  layout 'app'

  before_filter :login_required

	FirstFetchSize = 2

	FetchSize = 2

	FeedCategory = ['status', 'blog', 'video', 'all_album_related', 'all_event_related', 'all_poll_related', 'all_guild_related']

  def show
		@feed_deliveries = current_user.feed_deliveries.find(:all, :limit => FirstFetchSize)
	end

	def feeds
		if params[:type].blank?
			@feed_deliveries = current_user.feed_deliveries.find(:all, :limit => FirstFetchSize)
		else
			logger.error "current_user.#{FeedCategory[params[:type].to_i]}_feed_deliveries.find(:all, :limit => FirstFetchSize)"
			@feed_deliveries = eval("current_user.#{FeedCategory[params[:type].to_i]}_feed_deliveries.find(:all, :limit => FirstFetchSize)")
		end
	end

	def more_feeds
		if params[:type].blank?
      @feed_deliveries = current_user.feed_deliveries.find(:all, :offset => FirstFetchSize + FetchSize*params[:idx].to_i, :limit => FetchSize)
    else
      @feed_deliveries = eval("current_user.#{FeedCategory[params[:type].to_i]}_feed_deliveries.find(:all, :offset => FirstFetchSize + FetchSize*params[:idx].to_i, :limit => FirstFetchSize)")
    end
	end

end
