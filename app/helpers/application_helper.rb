# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def avatar_image(user, size="small")
    if user.avatar.blank?
      image_tag "default_#{size}.png"
    else
      image_tag user.avatar.public_filename(size)
    end
  end

  def avatar(user, opts={})
		size = opts.delete(:size) || "medium"
    if user.avatar.blank?
      link_to image_tag("default_#{size}.png", opts), profile_url(user.profile), :popup => true
    else
      link_to image_tag(user.avatar.public_filename(size), opts), profile_url(user.profile), :popup => true
    end
  end

  def profile_link(user, opts={})
    link_to user.login, profile_url(user.profile), opts
  end

  def validation_image
    "<img src='/application/new_validation_image' onclick='alert(\"begin\");this.src=\"/application/new_validation_image\";alert(\"done\");' />"
  end

  def ftime(time)
    time.strftime("%Y-%m-%d %H:%M") unless time.blank?
  end

  def ftime2(time)
    time.strftime("%Y-%m-%d") unless time.blank?
  end

  def ftime3(time)
    time.strftime("%m-%d") unless time.blank?
  end

  def ftime4(time)
    time.strftime("%H: %M") unless time.blank?
  end

  def gender_select_tag obj
    select_tag "#{obj.class.to_s.underscore}[gender]", options_for_select([['男', 'male'], ['女', 'female']], obj.gender) 
  end
  
  def privilege_select_tag(object)
    select_tag "#{object}[privilege]", options_for_select([['所有人', 1], ['好友及玩相同游戏的朋友', 2], ['好友', 3], ['自己', 4]], eval("@#{object}.privilege"))
  end

  def privacy_select_tag(obj, field)
    select_tag "#{obj}[#{field}]", options_for_select([['所有人', 1],  ['好友及玩相同游戏的朋友', 2], ['好友', 3]], eval("@#{obj}.#{field}"))
  end

  def friend_privacy_select_tag(obj, field)
    select_tag "#{obj}[#{field}]", options_for_select([['所有人', 1],  ['玩相同游戏的朋友', 2]], eval("@#{obj}.#{field}"))
  end

  def poll_privilege_select_tag(object)
    select_tag "#{object}[privilege]", options_for_select([['所有人', 1], ['好友', 2]], eval("@#{object}.privilege"))
  end

  def get_subject(user)
    if(current_user == user)
      "我"
    else
      if user.gender == 'male'
        "他"
      else
        "她"
      end
    end
  end

  def album_cover(album, opts={})
		size = opts.delete(:size) || 'medium'
    if album.cover_id.blank?
      link_to image_tag("default_cover_#{size}.png", opts), eval("#{album.class.to_s.underscore}_url(album)")
    else
      link_to image_tag(album.cover.public_filename(size), opts), eval("#{album.class.to_s.underscore}_url(album)")
    end
  end

  def album_link album
    link_to (truncate album.title, :length => 20), eval("#{album.type.underscore}_url(album)")
  end

  def photo_link(photo, opts={})
		size = opts.delete(:size) || "large"
    link_to (image_tag photo.public_filename(size), opts), eval("#{photo.type.underscore}_url(photo)")
  end

  def dig_link diggable
    (link_to_remote '挖', :url => eval("#{diggable.class.to_s.underscore}_digs_url(diggable)")) + 
    "(<span id='dig_#{diggable.class.to_s.underscore}_#{diggable.id}'>#{diggable.digs_count}</span>)"
  end

  def blog_link blog
    link_to (truncate blog.title, :length => 20), blog_url(blog)
  end

	def video_link video
		link_to (truncate video.title, :length => 20), video_url(video)
	end

  def game_link game
    link_to game.name, game_url(game)
  end

  def event_link event
    link_to (truncate event.title, :length => 20), event_url(event)
  end

	def poll_link poll
		link_to (truncate poll.name, :length => 20), poll_url(poll)
	end

	def guild_link guild
		link_to (truncate guild.name, :length => 20), guild_url(guild)
	end

	def forum_link forum
		link_to (truncate forum.name, :length => 20), forum_url(forum)
	end

	def topic_link topic
		link_to (truncate topic.subject, :length => 40), forum_topic_url(topic.forum, topic)
	end

	def mail_link mail
		if mail.recipient == current_user # in recv box
			if mail.read_by_recipient
				link_to mail.title, mail_url(mail, :type => 1), :id => "mail_title_#{mail.id}"
			else
				link_to "<h3>#{mail.title}</h3>", mail_url(mail, :type => 1), :id => "mail_title_#{mail.id}"
			end
		else # in sent box
			link_to mail.title, mail_url(mail, :type => 0), :id => "mail_title_#{mail.id}"
		end
	end

	def mail_select_tag
    select_tag 'select', options_for_select([['---', '^_^'], ['全部选中','all'], ['选读过的', 'read'], ['选没读的', 'unread'], ['取消全选', 'none']], "---"), :onchange => "mailbox.select_dropdown_onchange()"
  end

	def button_submit text
		"<button type='submit'>#{text}</button>"
	end

end
