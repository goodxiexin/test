class GuildAlbum::PhotosController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :president_or_veteran_required, :only => [:new, :record_upload, :edit_multiple, :update_multiple]

  before_filter :owner_required, :only => [:edit, :update, :destroy]

  def new
  end

  def show
    @membership = @guild.memberships.find_by_user_id(current_user.id)
    @comments = @photo.comments
  end

	def create
		if @photo = @album.photos.create(:album_id => @album.id, :game_id => @album.game_id, :swf_uploaded_data => params[:Filedata])
			render :text => @photo.id
		else
			# TODO
		end
	end

  def record_upload 
		if @album.record_upload current_user, @photos
			render :update do |page|
				page.redirect_to edit_multiple_guild_photos_url(:album_id => @album.id, :ids => @photos.map {|p| p.id})
			end
		end
	end 

  def edit
    render :action => 'edit', :layout => false 
  end

  def update
    @album.update_attribute('cover_id', @photo.id) if params[:cover]
    if @photo.update_attributes(params[:photo])
			respond_to do |format|
				format.json { render :json => @photo }
				format.html {
					render :update do |page|
						page << "facebox.close();"
						page << "$('guild_photo_notation_#{@photo.id}').innerHTML = '#{@photo.notation}';"
					end
				}
			end
    else
      # TODO
    end
  end

  def edit_multiple
  end

  def update_multiple
    @album.update_attribute('cover_id', params[:cover_id]) if params[:cover_id]
    @photos.each {|photo| photo.update_attributes(params[:photos]["#{photo.id}"]) }
    redirect_to guild_album_url(@album)
  end

  def destroy
    @photo.destroy
    render :update do |page|
      page.redirect_to guild_album_url(@album)
    end
  end

  def update_notation
    if @photo.update_attributes(params[:photo])
      render :text => @photo.notation
    end 
  end

protected

  def setup
    if ['show', 'edit', 'update', 'update_notation', 'destroy'].include? params[:action]
      @photo = GuildPhoto.find(params[:id])
      @album = @photo.album
      @guild = @album.guild
      @user = @guild.president
			@reply_to = User.find(params[:reply_to]) if params[:reply_to]
    elsif ['new', 'create'].include? params[:action]
      @album = GuildAlbum.find(params[:album_id])
      @guild = @album.guild
      @user = @guild.president
    elsif ['record_upload', 'edit_multiple'].include? params[:action]
      @album = GuildAlbum.find(params[:album_id])
      @guild = @album.guild
      @user = @guild.president
      @photos = params[:ids].blank? ? [] : @album.photos.find(params[:ids])
    elsif ['update_multiple'].include? params[:action]
      @album = GuildAlbum.find(params[:album_id])
      @guild = @album.guild
      @user = @guild.president
      @photos = params[:photos].blank? ? [] : @album.photos.find(params[:photos].map {|id, attribute| id})
    end
  rescue
    not_found
  end

  def president_or_veteran_required
    @guild.president == current_user || @guild.veterans.include?(current_user) || not_found
  end 

end
