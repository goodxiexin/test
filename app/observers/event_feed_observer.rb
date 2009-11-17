class EventFeedObserver < ActiveRecord::Observer

	observe :event

	def after_create(event)
		return unless event.poster.application_setting.emit_event_feed
		item = event.feed_items.create
		event.poster.profile.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Event')
		event.poster.guilds.each do |g|
			g.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Event')
		end
		event.poster.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Event') if f.application_setting.recv_event_feed
		end
	end

end
