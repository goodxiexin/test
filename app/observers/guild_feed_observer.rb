class GuildFeedObserver < ActiveRecord::Observer

	observe :guild

	def after_create guild
		puts "in guild feed observer"
		return unless guild.president.application_setting.emit_guild_feed
		item = guild.feed_items.create
		guild.president.profile.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Guild')
		guild.president.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Guild') if f.application_setting.recv_guild_feed
		end
	end

end
