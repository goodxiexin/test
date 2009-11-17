class ParticipationFeedObserver < ActiveRecord::Observer

	observe :participation

	def after_update(participation)
		return unless participation.participant.application_setting.emit_event_feed
		return if [3,4,5].include? participation.status_was and [3,4,5].include? participation.status
		item = participation.feed_items.create
		participation.participant.profile.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Participation')
		participation.participant.guilds.each do |g|
			g.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Participation')
		end
		participation.participant.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Participation') if f.application_setting.recv_event_feed
		end
	end

end
