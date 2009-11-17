class Rating < ActiveRecord::Base
  
	belongs_to :rateable, :polymorphic => true, :counter_cache => true
  
  belongs_to :user

	# rating can't be destroyed once it's created,
	# however, it can be updated
	after_save :set_average

	MINIMUM = 1
	MAXIMUM = 5
	DEFAULT = 3

	def validate_on_create
		if rating < Rating::MINIMUM or rating > Rating::MAXIMUM
			errors.add_to_base('越界')
		end
		if rateable.ratings.find_by_user_id user_id 
			errors.add_to_base('你已经评价过了')
		end
	end

	def set_average
		rateable.update_attribute('average_rating', rateable.ratings.average(:rating))
	end
 
end
