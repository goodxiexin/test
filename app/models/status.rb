class Status < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User', :counter_cache => true

	acts_as_commentable :order => 'created_at ASC'

  acts_as_emotion_text :columns => [:content]

	has_many :feed_items, :dependent => :destroy, :as => 'originator'

end
