class CharactersController < ApplicationController

	before_filter :login_required, :setup

	before_filter :owner_required, :only => [:edit, :update]

	def new
	end
	
	def create
		@game.ratings.create(:rating => params[:game_rate], :user_id => current_user.id)
		@character = current_user.characters.build(params[:character])
		if @character.save
			render :partial => 'character', :object => @character
		else
			render :action => 'new'
		end
	end

	def edit
	end

	def update
		@rating.update_attribute('rating', params[:game_rate])
		if @character.update_attributes(params[:character])
			render :partial => 'character', :object => @character
		else
			render :action => 'edit'
		end
	end

protected

	def setup
		if ["new"].include? params[:action]
		elsif ["create"].include? params[:action]
			@game = Game.find(params[:character][:game_id])
		elsif ["edit"].include? params[:action]
			@character = current_user.characters.find(params[:id])
      @user = @character.user
			@rating = @character.game.find_rating_by_user(current_user)
		elsif ["update"].include? params[:action]
			@character = current_user.characters.find(params[:id])
			@user = @character.user
			@game = Game.find(params[:character][:game_id])
			@rating = @game.find_rating_by_user(current_user)
		end
	rescue
		not_found
	end

end
