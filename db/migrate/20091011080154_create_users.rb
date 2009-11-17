class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string	:login
      t.string	:email
      t.string	:gender
      t.string	:crypted_password,	:limit => 40
      t.string	:salt,			:limit => 40
      t.string	:remember_token
      t.datetime	:remember_token_expires_at
      t.string	:activation_code
      t.datetime	:activated_at
      t.string	:password_reset_code
      t.boolean	:enabled,	:default => false
			t.integer :avatar_id

			# settings
			t.integer :privacy_setting, :limit => 8, :default => PrivacySetting.default
			t.integer :mail_setting, :limit => 8, :default => MailSetting.default  
			t.integer :application_setting, :limit => 8, :default => ApplicationSetting.default

      # counters
      t.integer :friends_count, :default => 0 # done
			t.integer :personal_albums_count, :default => 0 # done
			t.integer :events_count, :default => 0
			t.integer :upcoming_events_count, :default => 0
			t.integer :past_events_count, :default => 0
			t.integer :guilds_count, :default => 0 # done
			t.integer :participated_guilds_count, :default => 0 # done
			t.integer :polls_count, :default => 0 
			t.integer :participated_polls_count, :default => 0
      t.integer :blogs_count, :default => 0 # done
      t.integer :drafts_count, :default => 0 # done
      t.integer :videos_count, :default => 0 # done
      t.integer :statuses_count, :default => 0 # done
      t.integer :requests_count, :default => 0 # done 
      t.integer :invitations_count, :default => 0 # done

      t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end
end
