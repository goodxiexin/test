class Game::AttentionsController < ApplicationController

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:destroy]
  
  def create
    if @attention = @game.attentions.create(:user_id => current_user.id)
			render :update do |page|
				page.replace_html "game_attention_#{@game.id}", "已关注"
				page.insert_html :top, 'my_attentions', :partial => 'game_suggestions/interested_game', :object => @game
			end
		else
			render :update do |page|
				page << "error('发生错误，稍后再试');"
			end
		end
	end 
    
  def destroy
    @attention.destroy
    render :update do |page|
			page << "$('attention_#{@attention.id}').remove();"
			page << "facebox.close();"
		end
  end
  
protected

  def setup
    if ["create"].include? params[:action]
      @game = Game.find(params[:game_id])
    elsif ["destroy"].include? params[:action]
      @game = Game.find(params[:game_id])
      @attention = @game.attentions.find(params[:id])
      @user = @attention.user # this is required by owner_required
    end
  rescue
    not_found
  end

end
