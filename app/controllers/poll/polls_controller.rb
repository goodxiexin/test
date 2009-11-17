class Poll::PollsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :friend_or_owner_required, :only => [:index]

  before_filter :owner_required, :only => [:edit, :update, :destroy] 

  def index
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @polls = @user.polls.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
  end

	def hot
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @polls = Poll.hot.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
	end

  def recent
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @polls = Poll.recent.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
	end

  def participated
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @polls = @user.participated_polls.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
  end

  def show
		@vote = @poll.votes.find_by_voter_id(current_user.id)
		@votable = (current_user == @user) || (@poll.privilege == 1) || (@poll.privilege == 2 and @user.has_friend? current_user)
    @comments = @poll.comments
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(params[:poll].merge({:poster_id => @user.id}))
    if @poll.save
      params[:answers].each do |answer_attribute| 
        @poll.answers.create(answer_attribute) unless answer_attribute[:description].blank?
      end
      redirect_to poll_url(@poll)
    else
      render :action => 'new'
    end
  end

  def edit
    if params[:type].to_i == 0
      render :action => 'edit_end_date', :layout => false
    else
      render :action => 'edit_summary', :layout => false
    end
  end

  def update
    if @poll.update_attributes(params[:poll])
      render :update do |page|
        page << "facebox.close();"
        page << "$('end_date').innerHTML = '#{@poll.end_date.strftime("%Y-%m-%d")}';"
      end
    else
      render :update do |page|
        page << "error('错误');"
      end
    end 
  end

  def destroy
    @poll.destroy
    render :update do |page|
      page << "facebox.close();"
      page.redirect_to polls_url(:id => @user.id)
    end
  end

protected

  def setup
    if ['index', 'participated', 'hot', 'recent'].include? params[:action]
      @user = User.find(params[:id])
    elsif ['show', 'edit', 'update', 'destroy'].include? params[:action]
      @poll = Poll.find(params[:id])
      @user = @poll.poster
			@reply_to = User.find(params[:reply_to]) if params[:reply_to]
    elsif ['new', 'create'].include? params[:action]
      @user = current_user
    end
  rescue
    not_found  
  end

end
