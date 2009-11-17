class PersonalAlbum::AlbumsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:select, :edit, :update, :confirm_destroy, :destroy]

  before_filter :friend_or_owner_required, :only => [:index]

  def index
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @albums = @user.albums.viewable(relationship, :conditions => cond).push @user.avatar_album
		@albums = @albums.paginate :page => params[:page], :per_page => 10
  end

	def recent
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @albums = PersonalAlbum.recent.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 5
  end

  def select
    @albums = @user.albums
  end

  def show
		@comments = @album.comments 
  end

  def new
    @album = PersonalAlbum.new
    render :action => 'new', :layout => false
  end

  def create
    @album = @user.albums.build(params[:album].merge({:poster_id => @user.id}))
    if @album.save
			render :update do |page|
				page.redirect_to personal_albums_url(:id => @user.id)
			end
    else
      render :update do |page|
        page.replace_html 'errors', :partial => 'validation_errors'
      end
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    if @album.update_attributes(params[:album])
			respond_to do |format|
        format.json { render :json => @album }
        format.html {    
					render :update do |page|
						page.alert '成功'
					end
				}
			end
    else
      render :update do |page|
        page.replace_html 'errors', :partial => 'validation_errors'
      end
    end
  end 

  def confirm_destroy
    render :action => 'confirm_destroy', :layout => false
  end

  def destroy
    if params[:migration] and params[:migration].to_i == 1 and !params[:album][:id].blank?
      Photo.update_all("album_id = #{params[:album][:id]}", "album_id = #{@album.id}")
    end
    @album.destroy
		render :update do |page|
			page.redirect_to personal_albums_url(:id => @user.id)  
		end
	end

protected

  def setup
    if ["index", "recent"].include? params[:action]
      @user = User.find(params[:id])
    elsif ["show", "edit", "update", "confirm_destroy", "destroy"].include? params[:action]
      @album = PersonalAlbum.find(params[:id])
      @user = @album.user
			@privilege = @album.privilege
			@reply_to = User.find(params[:reply_to]) if params[:reply_to]
    elsif ["new", "create", "select"].include? params[:action]
      @user = current_user
    end
  rescue
    not_found
  end

end
