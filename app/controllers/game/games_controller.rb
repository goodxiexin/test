class Game::GamesController < ApplicationController

	layout 'app2'

  before_filter :login_required, :setup

	def show
		@blogs = @game.blogs.find(:all, :limit => 3)
		@albums = @game.albums.find(:all, :limit => 3)
		@tagging = @game.taggings.find_by_poster_id(current_user.id)
		@taggable = @tagging.nil? || (@tagging.created_at < 1.week.ago) || false
		@comments = @game.comments.paginate :page => 1, :per_page => 10
	end
	
  def game_details
		unless @game.no_areas?
			render :json => {:no_areas => false, :areas => @game.areas, :professions => @game.professions, :races => @game.races}
		else
			render :json => {:no_areas => true, :servers => @game.servers, :professions => @game.professions, :races => @game.races}
		end
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
