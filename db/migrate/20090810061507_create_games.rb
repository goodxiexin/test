class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games, :force => true do |t|
      t.string :name
      t.string :official_web
      t.string :company
      t.string :agent
      t.date :sale_date
      t.text :description
			t.float :average_rating, :default => 0
      t.boolean :no_areas, :default => false
      t.boolean :no_races, :default => false
      t.boolean :no_professions, :default => false
      t.integer :areas_count, :default => 0
      t.integer :servers_count, :default => 0
      t.integer :professions_count, :default => 0
      t.integer :races_count, :default => 0
			t.integer :attentions_count, :default => 0
			t.integer :ratings_count, :default => 0
			t.integer :comments_count, :default => 0
      t.boolean :stop_running, :default => false
      t.timestamps
    end
  end


  def self.down
    drop_table :games
  end
end
