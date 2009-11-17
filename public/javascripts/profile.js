ProfileManager = Class.create({

  initialize: function(profile_id){
    this.profile_id = profile_id;
    this.loading_image = new Image();
    this.loading_image.src = "/images/loading.gif";
    this.binfo = $('basic_info');
    this.binfo_head = this.binfo.childElements()[0];
    this.binfo_body = this.binfo.childElements()[1];
    this.cinfo = $('contact_info');
		this.cinfo_head = this.cinfo.childElements()[0];
		this.cinfo_body = this.cinfo.childElements()[1];
    this.ginfo = $('character_info');
		this.ginfo_head = this.ginfo.childElements()[0];
		this.ginfo_body = this.ginfo.childElements()[1];
		this.character_forms = new Hash();
  },

	loading: function(div){
		div.innerHTML = "<img src='" + this.loading_image.src + "'/>";
	},

  edit_basic_info: function(){
    // change css class of this.binfo_head
    this.old_binfo = this.binfo_body.innerHTML;
    if(this.binfo_form){
      this.binfo_body.innerHTML = this.binfo_form;
    }else{
      this.loading(this.binfo_body);
      new Ajax.Request('/profiles/' + this.profile_id + '/edit?type=1', {
        method: 'get',
        onSuccess: function(transport){
          this.binfo_form = transport.responseText;
          this.binfo_body.innerHTML = this.binfo_form;
        }.bind(this)
      });
    }
  },

  leave_edit_basic_info: function(){
    this.binfo_body.innerHTML = this.old_binfo; 
  },

  validate_basic_info: function(){
    return true;
  },

  update_basic_info: function(){
    if(this.validate_basic_info()){
      new Ajax.Request('/profiles/' + this.profile_id + '?type=1', {
        method: 'put',
        parameters: $('basic_info_form').serialize(),
        onSuccess: function(transport){
          this.binfo_form = null;
          //this.binfo_head
          this.binfo_body.innerHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  edit_contact_info: function(){
    // change css class of this.cinfo_head
    this.old_cinfo = this.cinfo_body.innerHTML;
    if(this.cinfo_form){
      this.cinfo_body.innerHTML = this.cinfo_form;
    }else{
      this.loading(this.cinfo_body);
      new Ajax.Request('/profiles/' + this.profile_id + '/edit?type=2', {
        method: 'get',
        onSuccess: function(transport){
          this.cinfo_form = transport.responseText;
          this.cinfo_body.innerHTML = this.cinfo_form;
        }.bind(this)
      });
    }
  },

  leave_edit_contact_info: function(){
    this.cinfo_body.innerHTML = this.old_cinfo;
  },

  validate_contact_info: function(){
    return true;
  },

  update_contact_info: function(){
    if(this.validate_contact_info()){
      new Ajax.Request('/profiles/' + this.profile_id + '?type=2', {
        method: 'put',
        parameters: $('contact_info_form').serialize(),
        onSuccess: function(transport){
          this.cinfo_form = null;
          //this.cinfo_head
          this.cinfo_body.innerHTML = transport.responseText;
        }.bind(this)
      });
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

  setup_rating_info: function(rating){
	    $('current_rate').innerHTML = "<li class='current-rating' style='width:"+ rating*30 +"px;'> Currently "+ rating +"/5 Stars.</li>";
        $('star_value').innerHTML = "<input id='game_rate' type='hidden' value='"+ rating +"' name='game_rate'/>";
  },

  setup_race_info: function(races){
    var html = '';
    for(var i=0;i<races.length;i++){
      html += "<option value='" + races[i].game_race.id + "'>" + races[i].game_race.name + "</option>";
    }
    $('character_race_id').innerHTML = html;
  },

    reset_area_info: function(){
        $('character_area_id').innerHTML = '';
    },

    reset_server_info: function(){
        $('character_server_id').innerHTML = '';
    },

	game_onchange: function(){
		new Ajax.Request('/games/' + $('character_game_id').value + '/game_details', {
			method: 'get',
			onSuccess: function(transport){
				this.details = transport.responseText.evalJSON();
                if (this.details.no_servers){
                    this.reset_area_info();
                    this.reset_server_info();
				}else if(!this.details.no_areas){
					this.setup_area_info(this.details.areas);
					this.area_onchange();
				}else{
                    this.reset_area_info();
					this.setup_server_info(this.details.servers);
				}
                this.setup_rating_info(this.details.rating);
				this.setup_profession_info(this.details.professions);
				this.setup_race_info(this.details.races);
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

	new_character_info: function(){
		// change head CSS
		this.old_ginfo = this.ginfo_body.innerHTML;
		if(this.new_form){
			this.ginfo_body.innerHTML = this.new_form;
		}else{
			this.loading(this.ginfo_body);
			new Ajax.Request('/characters/new', {
				method: 'get',
				onSuccess: function(transport){
					this.new_form = transport.responseText;
					this.ginfo_body.innerHTML = this.new_form;
				}.bind(this)
			});
		}
	},

	leave_new_character_info: function(){
		this.ginfo_body.innerHTML = this.old_ginfo;
	},

	create_character_info: function(){
		if(this.validate_character_info(true)){
			new Ajax.Request('/characters/', {
				method: 'post',
				parameters: $('character_info_form').serialize(),
				onSuccess: function(transport){
					this.ginfo_body.innerHTML = this.old_ginfo;
					Element.insert($('characters'), {top: transport.responseText});
				}.bind(this)
			});
		}
	},

	edit_character_info: function(character_id){
    // change css class of this.ginfo_head
		var form = this.character_forms.get(character_id);
		this.old_ginfo = this.ginfo_body.innerHTML;
    if(form){
      this.ginfo_body.innerHTML = form;
    }else{
      this.loading(this.ginfo_body);
      new Ajax.Request('/characters/' + character_id + '/edit', {
        method: 'get',
        onSuccess: function(transport){
					form = transport.responseText;
					this.character_forms.set(character_id, form);
					this.ginfo_body.innerHTML = form;
        }.bind(this)
      });
    }
  },

  leave_edit_character_info: function(character_id){
		this.ginfo_body.innerHTML = this.old_ginfo;
  },

  validate_character_info: function(new_data){
  if($('character_name').value == ''){
    error("人物昵称不能不添呀");
    return false;
  }
  if($('character_level').value == ''){
    error('等级不能不添啊');
    return false
  }
  if($('character_game_id').value == ''){
    error('没有选择游戏，如有问题，请看提示');
  }
  if($('character_server_id').value == ''){
    error('没有选择服务器，如有问题，请看提示');
    return false;
  }
  if (new_data){
  if(this.details.no_servers){
    tip("由于游戏数量庞大，很多游戏已经停服，我们没有把所有游戏统计完成。这个游戏的资料就还不完全，请您在左边的意见／建议中告诉我们您所在游戏的所在服务器，我们会以最快速度为您添加。对您带来得不便，我们道歉。");
    return false;
  }
  if(!this.details.no_areas && $('character_area_id').value == ''){
    error('没有选择区域，如有问题，请看提示');
    return false;
  }
  if(!this.details.no_races && $('character_race_id').value == ''){
    error('没有选择种族');
    return false;
  }
  if(!this.details.no_professions && $('character_profession_id').value == ''){
    error('没有选择职业');
    return false;
  }
  }
  return true;
  },

  update_character_info: function(character_id){
    if(this.validate_character_info(false)){
      new Ajax.Request('/characters/' + character_id , {
        method: 'put',
        parameters: $('character_info_form').serialize(),
        onSuccess: function(transport){
					this.character_forms.unset(character_id);
          //this.ginfo_head
					this.ginfo_body.innerHTML = this.old_ginfo;
					Element.replace($('character_' + character_id), transport.responseText);
        }.bind(this)
      });
    }
  },

});

ProfileFeeder = Class.create({

	initialize: function(id){
		this.idx = 0;
		this.id = id;
	},

	more_feeds: function(){
		new Ajax.Request('/profiles/' + this.id + '/more_feeds?idx=' + this.idx, {
			method: 'get',
			onSuccess: function(transport){
				this.idx++;
			}.bind(this)
		});
	}

});
