class VoteFeedObserver < ActiveRecord::Observer

	observe :vote

	def after_create vote
		return unless vote.voter.application_setting.emit_poll_feed
		item = vote.feed_items.create
		vote.voter.profile.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Vote')
		vote.voter.guilds.each do |g|
      g.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Vote')
    end	
		vote.voter.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Vote') if f.application_setting.recv_poll_feed
		end
	end

end
