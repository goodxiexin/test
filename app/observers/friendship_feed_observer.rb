class FriendshipFeedObserver < ActiveRecord::Observer

	observe :friendship

	def after_update friendship
		if friendship.status_was == 0 and friendship.status == 1
			item = friendship.feed_items.create(:data => {:friend => friendship.user_id})
			friendship.user.profile.feed_deliveries.create(:feed_item_id => item.id)
			friendship.user.friends.each do |f|
				f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Friendship')
			end
			item = friendship.feed_items.create(:data => {:friend => friendship.friend_id})
			friendship.friend.profile.feed_deliveries.create(:feed_item_id => item.id)
      friendship.friend.friends.each do |f|
        f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Friendship')
      end
		end
	end

end
