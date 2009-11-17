class CreateGuilds < ActiveRecord::Migration
  def self.up
    create_table :guilds do |t|
      t.string :name
      t.integer :game_id
      t.string :description

      # counters
			t.integer :members_count, :default => 0
			t.integer :veterans_count, :default => 0
			t.integer :presidents_count, :default => 0
			t.integer :invitees_count, :default => 0
			t.integer :requestors_count, :default => 0 
			t.integer :comments_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :guilds
  end
end
