class Game < ActiveRecord::Base

  has_many :servers, :class_name => 'GameServer', :dependent => :destroy
  
  has_many :areas, :class_name => 'GameArea', :dependent => :destroy

  has_many :professions, :class_name => 'GameProfession', :dependent => :destroy

  has_many :races, :class_name => 'GameRace', :dependent => :destroy

	has_many :events, :order => 'confirmed_count DESC'

	has_many :guilds, :order => '(members_count + veterans_count + presidents_count) DESC'

	has_many :albums, :class_name => 'PersonalAlbum', :order => "uploaded_at DESC", :conditions => ["photos_count != ?", 0]

	has_many :blogs, :order => 'digs_count DESC'

	acts_as_taggable
  
	acts_as_rateable

	acts_as_commentable :order => 'created_at DESC'

	has_many :attentions, :class_name => 'GameAttention'

	def new_game?
		sale_date.nil? or sale_date > Date.today
	end

  def relative_new?
		sale_date.nil? or sale_date > Date.today<<(6)
	end  

	def self.attention_list limit
		find(:all, :conditions => "attentions_count != 0", :order => "attentions_count DESC", :limit => limit)
	end

	def self.beta_list limit
		find(:all, :conditions => ["sale_date > ?", Time.now.to_s(:db)], :order => 'sale_date DESC', :limit => limit)
	end

end
