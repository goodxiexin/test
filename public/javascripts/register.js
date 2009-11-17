CharacterInfo = Class.create({
	
	initialize: function(id, name, level, game_id, game, area_id, area, server_id, server, profession_id, profession, race_id, race){
		this.id = id;
		this.name = name;
		this.level = level;
		this.game_id = game_id;
		this.game = game;
		this.area_id = area_id;
		this.area = area;
		this.server_id = server_id;
		this.server = server;
		this.profession_id = profession_id;
		this.profession = profession;
		this.race_id = race_id;
		this.race = race;
	},

	name: function() { return this.name; },

	level: function() { return this.level;},

	game_id: function() { return this.game_id;},

	area_id: function() { return this.area_id;},

	server_id: function() { return this.server_id; },

	profession_id: function() { return this.profession_id; },

	race_id: function() { return this.race_id; },

	to_html: function(){
		var html = '';
		html += "<li id='character_" + this.id + "'>";
		html += "<h4>" + this.name + "</h4>";
		html += "<a href=# onclick='register_manager.edit_character(" + this.id + ")'>编辑</a>";
		html += "<a href=# onclick='register_manager.remove_character(" + this.id +")'>删除</a>";
		html += "<div><p>等级:" + this.level + "</p>";
		html += "<p>游戏:" + this.game + "</p>";
		if(this.area != null)
			html += "<p>服务区:" + this.area + "</p>";
		html += "<p>服务器:" + this.server + "</p>";
		html += "<p>职业:" + this.profession + "</p>";
		html += "<p>种族:" + this.race + "</p>";
		html += "</div></li>";
		return html;
	},

	to_hash: function(){
		return {
			'id'	: this.id,
			'character[name]'			: this.name,
			'character[level]'		:	this.level,
			'character[game_id]'	:	this.game_id,
			'character[area_id]'	:	this.area_id,
			'character[server_id]':	this.server_id,
			'character[profession_id]' : this.profession_id,
			'character[race_id]'	:	this.race_id
		}
	}
	
});

RegisterManager = Class.create({

	initialize: function(){
		this.form = $('register_form');
		this.login_info = $('login_info');
		this.login = $('user_login');
		this.email_info = $('email_info');
		this.email = $('user_email');
		this.gender = $('user_gender');
		this.password_info = $('password_info');
		this.password = $('user_password');
		this.confirmation_info = $('password_confirmation_info');
		this.password_confirmation = $('user_password_confirmation');
		this.character_info = $('character_info');
		this.characters = new Hash();
		this.character_id = 0;
		this.loading_image = new Image();
		this.loading_image.src = '/images/loading.gif';
	},

	load: function(div){
		div.innerHTML = '<img src="' + this.loading_image.src + '"/>';
	},

	show_login_requirement: function(){
		this.login_info.innerHTML = '只能由数字，字母组成，大小4-16字符';
	},

	validate_login: function(){
		if(this.login.value == ''){
			this.login_info.innerHTML = '不能为空';
			return false;
		}

		if(this.login.value.length < 6){
			this.login_info.innerHTML = '至少要4个字符';
			return false;
		}
		if(this.login.value.length > 16){
		  this.login_info.innerHTML = '最多16个字符';
			return false;
		}

		first = this.login.value[0];
		if((first >= 'a' && first <= 'z') || (first >= 'A' && first <= 'Z')){
			if(this.login.value.match(/[A-Za-z0-9\_]+/)){
				this.login_info.innerHTML = '合法';
				return true;
			}else{
				this.login_info.innerHTML = '只允许字母和数字';
				return false;
			}
		}else{
			this.login_info.innerHTML = '必须以字母开头';
			return false;
		}
	},

	show_email_requirement: function(){
		this.email_info.innerHTML = '输入合法的邮件地址';
	},

	validate_email: function(){
		if(this.email.value == ''){
		  this.email_info.innerHTML = '邮件不能为空';
		  return false;
		}

		if(this.email.value.match(/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/)){
			this.load(this.email_info);
			new Ajax.Request('/register/validates_email_uniqueness?email='+encodeURIComponent(this.email.value), {
			  onSuccess: function(transport){
			    if(transport.responseText == 'yes'){
			      this.email_info.innerHTML = '合法';
			    }else{
			      this.email_info.innerHTML = '该邮箱已被注册';
			    }
				}
			});
			return true;
		}else{
			this.email_info.innerHTML = '非法的邮件格式';
			return false;
		}
	},

	show_password_requirement: function(){
		this.password_info.innerHTML = '密码6－20个字符';
	},

	validate_password: function(){
		var strongReg = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
		var mediumReg = new RegExp("^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");

		// check length
		if(this.password.value.length < 6){
		  this.password_info.innerHTML = '至少6个字符';
		  return false;
		}
		if(this.password.value.length > 20){
		  this.password_info.innerHTML = '最多20个字符';
		  return false;
		}

		// check strength
		if(this.password.value.match(strongReg)){
		  this.password_info.innerHTML = '密码强度: 强';
		  return true;
		}else if(this.password.value.match(mediumReg)){
		  this.password_info.innerHTML = '密码强度: 中';
		  return true;
		}else{
			this.password_info.innerHTML = '密码强度: 弱';
			return true;
		}
	},

	show_password_confirm_requirement: function(){
		this.confirmation_info.innerHTML = '确认你的密码';
	},

	validate_password_confirmation: function(){
		if(this.password.value == ''){
		  this.password_info.innerHTML = '密码不能为空';
			return false;
		}

		if(this.password.value == this.password_confirmation.value){
			this.confirmation_info.innerHTML = '两次密码一致';
			return true;
		}else{
			this.confirmation_info.innerHTML = '两次密码不一致';
			return false;
		}
	},

	setup_area_info: function(areas){
    var html = '';
    for(var i=0;i<areas.length;i++){
      html += "<option value='" + areas[i].game_area.id + "'>" + areas[i].game_area.name + "</option>";
    }
    $('character_area_id').innerHTML = html;
  },

  setup_server_info: function(servers){
    var html = '';
    for(var i=0;i<servers.length;i++){
      html += "<option value='" + servers[i].game_server.id + "'>" + servers[i].game_server.name + "</option>";
    }
    $('character_server_id').innerHTML = html;
  },

  setup_profession_info: function(professions){
    var html = '';
    for(var i=0;i<professions.length;i++){
      html += "<option value='" + professions[i].game_profession.id + "'>" + professions[i].game_profession.name + "</option>";
    }
    $('character_profession_id').innerHTML = html;
  },

  setup_race_info: function(races){
    var html = '';
    for(var i=0;i<races.length;i++){
      html += "<option value='" + races[i].game_race.id + "'>" + races[i].game_race.name + "</option>";
    }
    $('character_race_id').innerHTML = html;
  },

	game_onchange: function(){
    new Ajax.Request('/games/' + $('character_game_id').value + '/game_details', {
      method: 'get',
      onSuccess: function(transport){
        var details = transport.responseText.evalJSON();
        if(!details.no_areas){
					this.no_areas = false;
          this.setup_area_info(details.areas);
          this.area_onchange();
        }else{
					this.no_areas = true;
          this.setup_server_info(details.servers);
        }
        this.setup_profession_info(details.professions);
        this.setup_race_info(details.races);
      }.bind(this)
    });
  },

  area_onchange: function(){
    new Ajax.Request('/games/' + $('character_game_id').value + '/area_details?area_id=' + $('character_area_id').value, {
      method: 'get',
      onSuccess: function(transport){
        var servers = transport.responseText.evalJSON();
        this.setup_server_info(servers);
      }.bind(this)
    });
  },

	validate_character_info: function(){
		$('character_name_info').innerHTML = '';
		$('character_level_info').innerHTML = '';
		$('character_game_info').innerHTML = '';
		$('character_area_info').innerHTML = '';
		$('character_server_info').innerHTML = '';
		$('character_profession_info').innerHTML = '';
		$('character_race_info').innerHTML = '';

		var name = $('character_name').value;
		var info = $('character_name_info');
		if(name == ''){
			info.innerHTML = '不能为空';
			return false;
		}

		var level = $('character_level').value;
		info = $('character_level_info');
		if(level.value == ''){
			info.innerHTML = '不能为空';
			return false;
		}else{
			if(parseInt(level)){
			}else{
				info.innerHTML = '等级应该是个整数';
				return false;
			}
		}

		var server_id = $('character_server_id').value;
		info = $('character_server_info');
	  if(server_id == '---'){
			info.innerHTML = '不能为空';
			return false;
		}

		race_id = $('character_race_id').value;
		info = $('character_race_info');
		if(race_id == '---'){
			info.innerHTML = '不能为空';
			return false;
		}

		profession_id = $('character_profession_id').value;
		info = $('character_profession_info');
	  if(profession_id == '---'){
			info.innerHTML = '不能为空';
			return false;
		}

		if(!this.no_areas){
			area_id = $('character_area_id').value;
			info = $('character_area_info');
			if(area_id == '---'){
				info.innerHTML = '不能为空';
				return false;
			}
		}

		return true;  
	},

	new_character: function(){
		this.old_character = this.character_info.innerHTML;
		if(this.new_form){
			this.character_info.innerHTML = this.new_form;
		}else{
			this.load(this.character_info);
			new Ajax.Request('/register/new_character', {
				method: 'get',
				onSuccess: function(transport){
					this.new_form = transport.responseText;
					this.character_info.innerHTML = this.new_form;
				}.bind(this)
			});
		}
	},

	leave_new_character: function(){
		this.character_info.innerHTML = this.old_character;
	},

	selected_text: function(list){
		for(var i=0;i<list.options.length;i++){
			if(list[i].selected){
				return list[i].text;
			}
		}
		return null;
	},

	create_character: function(){
		if(this.validate_character_info()){
			var character_info = new CharacterInfo(
      this.character_id,
      $('character_name').value,
      $('character_level').value,
      $('character_game_id').value,
      this.selected_text($('character_game_id')),
      $('character_area_id').value,
      this.selected_text($('character_area_id')),
      $('character_server_id').value,
      this.selected_text($('character_server_id')),
      $('character_profession_id').value,
      this.selected_text($('character_profession_id')),
      $('character_race_id').value,
      this.selected_text($('character_race_id')));
			this.characters.set(character_info.id, character_info);
			this.character_id += 1;
			this.character_info.innerHTML = this.old_character;
			Element.insert($('characters'), {top: character_info.to_html()});
		}
	},

	edit_character: function(character_id){
		var params = {character: this.characters.get(character_id).to_hash()};
    this.old_character = this.character_info.innerHTML;
    this.load(this.character_info);
    new Ajax.Request('/register/edit_character', {
      method: 'get',
			parameters: this.characters.get(character_id).to_hash(),
      onSuccess: function(transport){
				this.character_info.innerHTML = transport.responseText;
      }.bind(this)
    });
  },	

	leave_edit_character: function(){
    this.character_info.innerHTML = this.old_character;
  },

	update_character: function(character_id){
    if(this.validate_character_info()){
			var character_info = new CharacterInfo(
      this.character_id,
      $('character_name').value,
      $('character_level').value,
			$('character_game_id').value,
      this.selected_text($('character_game_id')),
			$('character_area_id').value,
      this.selected_text($('character_area_id')),
			$('character_server_id').value,
      this.selected_text($('character_server_id')),
			$('character_profession_id').value,
      this.selected_text($('character_profession_id')),
			$('character_race_id').value,
      this.selected_text($('character_race_id')));
			this.characters.set(character_id, character_info);
			this.character_info.innerHTML = this.old_character;
			Element.replace($('character_' + character_id), character_info.to_html());
		}
  },

	remove_character: function(character_id){
		this.characters.unset(character_id);
		$('character_' + character_id).remove();
	},

	submit: function(){
		if(!this.validate_login()) return; 
		if(!this.validate_email()) return;
		if(!this.validate_password()) return;
		if(!this.validate_password_confirmation()) return;

		if(this.characters.size() == 0){
			error('至少要有1个游戏角色');
			return;
		}
		
		// construct parameters
		var params = this.form.serialize() + '&';
		this.characters.each(function(p){
			var info = p.value;
			params += 'characters[][name]=' + info.name + '&';
			params += 'characters[][level]=' + info.level + '&';
			params += 'characters[][game_id]=' + info.game_id+ '&';
			params += 'characters[][area_id]=' + info.area_id+ '&';
			params += 'characters[][server_id]=' + info.server_id+ '&';
			params += 'characters[][profession_id]=' + info.profession_id+ '&';
			params += 'characters[][race_id]=' + info.race_id+ '&';
		});
		new Ajax.Request('/users', {method: 'post', parameters: params});	
	}

});

