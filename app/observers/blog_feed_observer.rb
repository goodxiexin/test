class BlogFeedObserver < ActiveRecord::Observer

	observe :blog

  def after_create(blog)
		return if blog.draft
		return unless blog.poster.application_setting.emit_blog_feed
		return if blog.privilege == 4 # only for myself
		item = blog.feed_items.create
		blog.poster.guilds.each do |g|
			g.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Blog')
		end
		blog.poster.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Blog') if f.application_setting.recv_blog_feed
		end
	end

  def after_update(blog)
		return unless blog.poster.application_setting.emit_blog_feed
		return if blog.privilege == 4
		if blog.draft_was and !blog.draft
			item = blog.feed_items.create
			blog.poster.guilds.each do |g|
				g.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Blog') 
			end
			blog.poster.friends.each do |f|
				f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Blog') if f.application_setting.recv_blog_feed
			end
		end
  end

end
