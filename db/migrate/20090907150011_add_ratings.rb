class AddRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.column :rating, :integer,  :default => 3   # You can add a default value here if you wish
      t.column :rateable_id, :integer, :null => false
      t.column :rateable_type, :string, :null => false
      t.column :user_id, :integer, :default => 0, :null => false
      t.column :created_at, :datetime
    end

    add_index :ratings, [:rateable_id, :rating]
  end

  def self.down
    drop_table :ratings
  end
end
