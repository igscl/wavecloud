class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_user, only: [:edit, :update, :destroy]
  

  # GET /profiles
  # GET /profiles.json
  def index
    unless Profile.exists?(current_user.id)
    redirect_to :action => 'new'
    #if the user profile has not been created, redirect to profile creation page when trying to access the index page
    else

    @profile = Profile.find(current_user.id)
    #finds the current user id session
    @track_donations = TrackDonation.where(:user_id => current_user.id).sum(:value)
    #This is using the TrackDonation model to find the donations of the current user and summing the values in the :value column. TrackDonation has a join table.
    @favorites = current_user.favorites
    #This relates to the current user favorites relation in the User model: a User has many favorites through: :favorite_tracks, source: :track
  end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    id = @profile.user_id
    #the @profile is in the set_profile method called in the before_action
    @user_tracks = User.find(id).tracks
    #finding the current_user tracks

  end

  # GET /profiles/new
  def new
    @profile = Profile.new
    #creating a new profile
  end

  # GET /profiles/1/edit
  def edit
    #not giving this functionality at this point in time
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.create(user_id: current_user.id, id: current_user.id)
    #creating a new user using the current_user data

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    if current_user == @profile.user_id
      respond_to do |format|
        if @profile.update(profile_params)
          format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
          format.json { render :show, status: :ok, location: @profile }
        else
          format.html { render :edit }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    if current_user.id == @profile.user_id
        @profile.destroy
        respond_to do |format|
          format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
        format.html { redirect_to profiles_url, notice: "Sorry, cannot delete other user's profile." }
        format.json { head :no_content }
        end
      end
      #added this when a user tries to delete another user's profile

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
      
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "User profile does not exist."
      redirect_to :action => 'index'
    end
    #added this rescue line for security purposes

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:user_id)
    end
    def authorize_user
      if current_user.id != @profile.user_id
        flash[:notice] = "Sorry, not authorized to do that."
        redirect_to :action => 'index'
      end
    end
end
