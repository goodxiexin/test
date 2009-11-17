class ProfileFeedObserver < ActiveRecord::Observer

	observe :profile

	def basic_info_changed? profile
		profile.gender_changed? ||
		profile.region_id_changed? ||
		profile.city_id_changed? ||
		profile.district_id_changed? ||
		profile.birthday_changed?
	end

	def contact_info_changed? profile
		profile.qq_changed? ||
		profile.phone_changed? ||
		profile.website_changed?
	end

	def after_update profile
		return unless profile.changed?
		modified = []
		if basic_info_changed? profile
			modified << "基本信息"
		end
		if contact_info_changed? profile
			modified << "联系信息"
		end
		return if modified.count == 0
		item = profile.feed_items.create(:data => {:modified => modified})
		profile.user.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'Profile')
		end
	end

end
