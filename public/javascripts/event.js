EventBuilder = Class.create({

  initialize: function(){
    this.title = $('event_title');
    this.description = $('event_description');
    this.game = $('event_game_id');
    this.area = $('event_game_area_id');
    this.server = $('event_game_server_id');
    this.start_time = $('event_start_time');
    this.end_time = $('event_end_time');
    this.privilege = $('event_privilege');
    this.form = $('event_form');
  },

  valid: function(){
    if(this.title.value == ''){
      error('标题不能为空');
      return false;
    }
    if(this.title.value.length > 100){
      error('标题太长，最长100个字符');
      return false;
    }
    if(this.description.value == ''){
      error('描述不能为空');
      return false;
    }
    if(this.description.value.length > 10000){
      error('描述最长10000个字符');
      return false;
    }
    if(this.game.value == ''){
      error('游戏类别不能为空');
      return false;
    }
    if(this.server.value == ''){
      error('服务器不能为空');
      return false;
    }
    if(this.area && this.area.value == ''){
      error('服务区不能为空');
      return false;
    }
    if(this.start_time.value == ''){
      error('开始时间不能为空');
      return false;
    }
    if(this.end_time.value == ''){
      error('结束时间不能为空');
      return false;
    }
    var current_time = new Date().getTime();
    var start_time = new Date(this.start_time.value).getTime();
    var end_time = new Date(this.end_time.value).getTime();
    if(start_time < current_time){
      error('开始时间不能比现在早');
      return false;
    }
    if(end_time <= start_time){
      error('结束时间不能比开始时间早');
      return false;
    }
  
    return true;
  },

  change_game: function(){
    new Ajax.Request('/games/' + this.game.value + '/game_details', {
      method: 'get',
      onSuccess: function(transport){
        var details = transport.responseText.evalJSON(); // pass parameter true if the source is not trusted
				var html = "";
				if(details.no_areas){
					var servers = details.servers;
					for(var i=0;i<servers.length;i++)
						html += "<option value=" + servers[i].game_server.id + ">" + servers[i].game_server.name + "</option>";
					this.server.innerHTML = html;
				}else{
					var areas = details.areas;	
					for(var i=0;i<areas.length;i++)
						html += "<option value=" + areas[i].game_area.id +">" + areas[i].game_area.name + "</option>";
					this.area.innerHTML = html;
					this.change_area();
				}
      }.bind(this)
    }); 
  },

  change_area: function(){
    new Ajax.Request('/games/' + this.game.value + '/area_details?area_id=' + this.area.value, {
      method: 'get',
      onSuccess: function(transport){
        var servers = transport.responseText.evalJSON();
        var html = "";
        for(var i = 0; i < servers.length; i++)
          html += "<option value=" + servers[i].game_server.id + ">" + servers[i].game_server.name + "</option>"
        this.server.innerHTML = html;
      }.bind(this)
    });
  },

  save: function(){
    if(this.valid()){
      this.form.action = '/events';
      this.form.submit();
    }
  },

  update: function(event_id){
    if(this.valide()){
      this.form.action = '/events/' + event_id;
      this.form.method = 'put';
      this.form.submit();
    }
  }

});
