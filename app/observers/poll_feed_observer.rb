class PollFeedObserver < ActiveRecord::Observer

	observe :poll

  def after_create(poll)
		return unless poll.poster.application_setting.emit_poll_feed
		item = poll.feed_items.create
		poll.poster.profile.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Poll')
		poll.poster.guilds.each do |g|
      g.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Poll') 
    end
		poll.poster.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Poll') if f.application_setting.recv_poll_feed
		end
	end

end
