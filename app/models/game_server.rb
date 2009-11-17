class GameServer < ActiveRecord::Base

  belongs_to :game, :counter_cache => 'servers_count'

  belongs_to :area, :class_name => 'GameArea', :counter_cache => 'servers_count'

end
