class GamesController < ApplicationController

	layout 'app2'

  before_filter :login_required, :setup

	def show
	end
	
  def game_details
	  render :json => {:no_areas => @game.no_areas, :no_races => @game.no_races, :no_professions => @game.no_professions, :no_servers => @game.no_servers, :areas => @game.areas, :professions => @game.professions, :races => @game.races, :rating => @game.find_rating_by_user(current_user).rating}
	end

	def area_details
		render :json => @area.servers
	end

protected

  def setup
		if["show", "game_details"].include? params[:action]
      @game = Game.find(params[:id])
    elsif ["game_details", "area_details"].include? params[:action]
			@game = Game.find(params[:id])
			@area = GameArea.find(params[:area_id])
		end
  rescue
    not_found
  end

end
