class Vote < ActiveRecord::Base

	serialize :answer_ids, Array

  belongs_to :voter, :class_name => 'User'

  belongs_to :poll, :counter_cache => :voters_count

	has_many :feed_items, :as => 'originator', :dependent => :destroy

	def answers
		PollAnswer.find(answer_ids)
	end

end
