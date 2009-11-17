class Profile < ActiveRecord::Base

	MAX_VISITOR_RECORDS = 9

  belongs_to :user

	belongs_to :region

	belongs_to :city

	belongs_to :district

	acts_as_commentable :order => 'created_at DESC'

	acts_as_taggable

	has_many :feed_items, :as => 'originator', :dependent => :destroy

	has_many :feed_deliveries, :as => 'recipient', :order => 'created_at DESC'

	has_many :visitor_records, :order => 'created_at DESC'

end

