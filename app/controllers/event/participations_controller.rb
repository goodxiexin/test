class Event::ParticipationsController < ApplicationController

  layout 'app2'

  before_filter :login_required, :setup

  before_filter :participation_required, :only => [:edit, :update]

  before_filter :participant_required, :only => [:edit, :update]

	before_filter :not_past_required, :only => [:index]

  def index
    case params[:type].to_i
    when 0
      @participants = @event.confirmed_participants.paginate :page => params[:page], :per_page => 20
    when 1
      @participants = @event.maybe_participants.paginate :page => params[:page], :per_page => 20
    when 2
      @participants = @event.declined_participants.paginate :page => params[:page], :per_page => 20
		when 3
			@participants = @event.invitees.paginate :page => params[:page], :per_page => 20
		when 4
			@participants = @event.requestors.paginate :page => params[:page], :per_page => 20
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    @participation.update_attributes(params[:participation])
  end

protected

  def setup
    if ["index"].include? params[:action]
      @event = Event.find(params[:event_id])
      @user = @event.poster
    elsif ["edit", "update"].include? params[:action]
      @event = Event.find(params[:event_id])
      @user = @event.poster
      @participation = @event.participations.find(params[:id])
    end
  rescue
    not_found
  end

	def not_past_required
		if [3,4].include? params[:type].to_i
			!@event.past || not_found
		end
	end

	# guarantee it's not request or invitation
  def participation_required
    [3,4,5].include? @participation.status || not_found
  end

  def participant_required
    current_user == @participation.participant || not_found
  end

end
