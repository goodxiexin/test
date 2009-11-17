class PersonalAlbum < Album

  belongs_to :cover, :class_name => 'PersonalPhoto'

  belongs_to :user, :foreign_key => 'owner_id', :counter_cache => :personal_albums_count

  has_many :photos, :class_name => 'PersonalPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

	named_scope :recent, :order => 'uploaded_at DESC'

	acts_as_privileged_resources

	def record_upload user, photos
	  if user.application_setting.emit_photo_feed and privilege != 4
      item = feed_items.create(:data => {:ids => photos.map(&:id)})
      user.guilds.each do |g|
        g.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'PersonalAlbum')
      end
      user.friends.each do |f|
        f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'PersonalAlbum') if f.application_setting.recv_photo_feed
      end
      update_attribute('uploaded_at', Time.now)
    end
	end	

end

