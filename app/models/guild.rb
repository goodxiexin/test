class Guild < ActiveRecord::Base
  
  belongs_to :game

  has_one :forum

  has_many :memberships

  has_many :invitations, :class_name => 'Membership', :conditions => {:status => 0}

  has_many :requests, :class_name => 'Membership', :conditions => {:status => [1,2]}

	with_options :through => :memberships, :source => 'user' do |guild|

		guild.has_many :all_members, :conditions => "memberships.status = 3 or memberships.status = 4 or memberships.status = 5"

		guild.has_many :requestors, :conditions => "memberships.status = 1 or memberships.status = 2"

		guild.has_many :invitees, :conditions => "memberships.status = 0"

		guild.has_many :members, :conditions => "memberships.status = 5"

		guild.has_many :veterans, :conditions => "memberships.status = 4"

		guild.has_one :president, :conditions => "memberships.status = 3"

		guild.has_many :veterans_and_members, :conditions => "memberships.status = 4 or memberships.status = 5"

		guild.has_many :president_and_veterans, :conditions => "memberships.status = 3 or memberships.status = 4"

	end

  has_one :album, :class_name => 'GuildAlbum', :foreign_key => 'owner_id'

  has_many :guild_friendships

  has_many :friends, :through => :guild_friendships, :source => 'friend'

	has_many :feed_items, :as => 'originator', :dependent => :destroy

	has_many :feed_deliveries, :as => 'recipient', :order => 'created_at DESC'

	acts_as_commentable :order => 'created_at DESC'

	named_scope :hot, :order => '(members_count + veterans_count + presidents_count) DESC'  
	
	named_scope :recent, :order => 'created_at DESC'

	searcher_column :name

  validate do |guild|
    guild.errors.add_to_base('名字不能为空') if guild.name.blank?
    guild.errors.add_to_base('名字最长100个字符') if guild.name.length > 100
    guild.errors.add_to_base('描述不能为空') if guild.description.blank?
    guild.errors.add_to_base('描述最长10000个字符') if guild.description.length > 10000
    guild.errors.add_to_base('游戏类别不能为空') if guild.game_id.blank?
  end

  def events
    self.president_and_veterans(:include => :events).map do |member|
      member.upcoming_events
    end.flatten.sort {|a,b| a.created_at <=> b.created_at}
  end

	# virtual attribute
	def president_id
		@president_id
	end

	def president_id=(id)
		@president_id = id
	end

	def all_count
		veterans_count + presidents_count + members_count
	end

end
