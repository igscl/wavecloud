class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index]

  # GET /profiles
  # GET /profiles.json
  def index
    unless Profile.exists?(current_user.id) == false
    redirect_to Profile.find(current_user.id)
    else 
      redirect_to :action => 'new'
    end
    # id = @profile.user_id
    # redirect_to profile_url(id)
    # @profile = Profile.find(current_user.id)
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    id = @profile.user_id
    @user_tracks = User.find(id).tracks

    # id = params[:id]
    # @user_tracks = Profile.find(id).user_id
    # @user_tracks = current_user.tracks
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.create(user_id: current_user.id, id: current_user.id)

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
