class GameArea < ActiveRecord::Base

  belongs_to :game, :counter_cache => 'areas_count'

  has_many :servers, :class_name => 'GameServer', :foreign_key => 'area_id'  

end
