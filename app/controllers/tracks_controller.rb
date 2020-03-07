class TracksController < ApplicationController
  before_action :set_track, only: [:show, :edit, :update, :destroy]
  before_action :set_genre, only: [:new, :edit, :create]
  before_action :authenticate_user!

  def index
    @tracks = Track.all
    # @tracks = User.find(1).tracks
    #Saving this into an instance variable. We want to save what we need right now.
  end

  def create
    @track = current_user.tracks.create(track_params)
    if @track.errors.any?
        render "new"
    else
        redirect_to root_path
    end
  end
  
  def new
    @track = Track.new
    #we're telling rails what to do when we submit the form in the new.html.erb view
  end
  
  def show
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer_email: current_user.email,
      line_items: [{
          name: @track.title,
          description: @track.description,
          amount: 100, #@track.donate * 100,         
          currency: 'aud',
          quantity: 1,
      }],
      payment_intent_data: {
          metadata: {
              user_id: current_user.id,
              track_id: @track.id
          }
      },
      success_url: "#{root_url}payments/success?userId=#{current_user.id}&trackId=#{@track.id}",
      cancel_url: "#{root_url}tracks"
  )

  @session_id = session.id
  end

  def edit
  end
  
  def update
    if @track.update(track_params)
      redirect_to @track
  else
      render 'edit'
  end
  end
  
  def destroy
    @track.destroy
 
    redirect_to root_path
  end

  private

  def track_params
      params.require(:track).permit(:title, :genre_id, :album, :description, :donate, :track_id, :audio)
      # The params that we require for the track are these
      # CHECK to change requirement to have a file to upload
  end

  def set_track
    id = params[:id]
    #getting the id that was put into the browser and saving it into the variable id
    @track = Track.find(id)
  end

  def set_genre
    @genre = Genre.all
  #testing this to see if I can add a foreign key
  end

end
