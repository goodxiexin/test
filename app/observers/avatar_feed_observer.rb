class AvatarFeedObserver < ActiveRecord::Observer

	observe :avatar

	def after_create avatar
		return if avatar.album.blank? or !avatar.album.poster.application_setting.emit_photo_feed 
		item = avatar.feed_items.create
		avatar.album.poster.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Avatar') if f.application_setting.recv_photo_feed
		end
	end

end
