class FeedItem < ActiveRecord::Base

	serialize :data, Hash

	belongs_to :provider, :class_name => 'User'

	belongs_to :originator, :polymorphic => true

	has_many :deliveries, :class_name => 'FeedDelivery', :dependent => :destroy

	before_create :set_expired_date

protected

	def set_expired_date
		self.expired_at = 1.month.from_now
	end

end
