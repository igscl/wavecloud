class TracksController < ApplicationController
  before_action :authenticate_user!
  #user needs to be logged in
  before_action :set_track, only: [:show, :edit, :update, :destroy, :favorite]
  before_action :set_genre, only: [:new, :edit, :create]

  def index
    @tracks = Track.all.order('created_at DESC')
    #ordering the tracks on the index page by date created in descending order
  end

  def create
    @track = current_user.tracks.create(track_params)
    #checking for the tracks parameters defined in the private method
    if @track.errors.any?
        render "new"
        #making sure this is handled if there are errors in the track creation.
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
          amount: 100, #@track.donate * 100 was the previous value. I just left it as static $1         
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

  # Add and remove favorite tracks
  # for current_user. We can see the relation directly on the User model
  def favorite
    type = params[:type]
    if type == "favorite"
      current_user.favorites << @track
      redirect_to track_url
    elsif type == "unfavorite"
      current_user.favorites.delete(@track)
      redirect_to track_url

    end
  end
  private

  def track_params
      params.require(:track).permit(:title, :genre_id, :album, :description, :donate, :track_id, :audio)
      # These are the params that we are permitting
  end

  def set_track
    id = params[:id]
    #getting the id that was put into the browser and saving it into the variable id and finding it
    @track = Track.find(id)

  end

  def set_genre
    @genre = Genre.all
  #this was added for testing. Not being used yet.
  end

end
