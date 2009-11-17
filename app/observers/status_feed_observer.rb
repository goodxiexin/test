class StatusFeedObserver < ActiveRecord::Observer

	observe :status

  def after_create(status)
		item = status.feed_items.create
		status.poster.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Status')
		end
	end

end
