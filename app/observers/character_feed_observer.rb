class CharacterFeedObserver < ActiveRecord::Observer

	observe :game_character

	def after_create character
		item = character.feed_items.create	
		character.user.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id, :item_type => 'GameCharacter')
		end
	end

end
