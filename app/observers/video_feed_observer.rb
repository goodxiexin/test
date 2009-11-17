class VideoFeedObserver < ActiveRecord::Observer

	observe :video

	def after_create(video)
		return unless video.poster.application_setting.emit_video_feed
		return if video.privilege == 4
		item = video.feed_items.create
		video.poster.guilds.each do |g|
      g.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Video') 
    end
		video.poster.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Video') if f.application_setting.recv_video_feed
		end
	end

end
