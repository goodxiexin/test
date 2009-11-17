# ActsAsRateable
# the origin plugin is out-of-date and is full of some useless methods
# author: 高毛
module Rateable

	def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_rateable opts={}
      has_many :ratings, :as => 'rateable', :dependent => :destroy

			if opts[:default]
				define_method(:default_rating) do
					opts[:default]
				end
			end

      include Rateable::InstanceMethods

      extend Rateable::SingletonMethods
    end   

  end

	module SingletonMethods
	
	end

	module InstanceMethods

		def find_rating_by_user user
			ratings.find_by_user_id(user.id)
		end
 
		def rated_by_user? user
			!ratings.find_by_user_id(user.id).nil?
		end 

	end

end
