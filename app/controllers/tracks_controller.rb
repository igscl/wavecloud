class TracksController < ApplicationController
  before_action :set_track, only: [:show, :edit, :update, :destroy]
  def index
    @tracks = Track.all
    #Saving this into an instance variable. We want to save what we need right now.
  end

  def create
    @track = Track.create(track_params)

    if @track.errors.any?
        render "new"
    else
        redirect_to root_path
    end
  end
  
  def new
  end
  
  def show
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
      params.require(:track).permit(:title, :genre_id, :album, :description, :donate, :track_id)
      # The params that we require for the track are these
      # CHECK to change requirement to have a file to upload
  end

  def set_track
    id = params[:id]
    #getting the id that was put into the browser and saving it into the variable id
    @track = Track.find(id)
  end

end
