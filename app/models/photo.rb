require 'mime/types'

class Photo < ActiveRecord::Base

  belongs_to :user

	belongs_to :album, :counter_cache => :photos_count

  acts_as_commentable :order => 'created_at ASC'

  acts_as_diggable

	has_many :tags, :class_name => 'PhotoTag', :dependent => :destroy

	has_many :relative_users, :through => :tags, :source => 'tagged_user'

	named_scope :hot, :conditions => ["parent_id IS NULL and created_at > ? and digs_count != 0", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC"

	acts_as_privileged_resources

	has_many :feed_items, :as => 'originator', :dependent => :destroy

  def is_cover?
    album.cover_id == id
  end

	def swf_uploaded_data=(data)
    data.content_type = MIME::Types.type_for(data.original_filename)
    self.uploaded_data = data
  end

end
