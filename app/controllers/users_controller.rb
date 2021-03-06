class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy, :my_friends]
  before_action :require_admin, only: [:destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to user_path(@user), notice: "#{@user.username} was successfully logged." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User and all of articles whiche created by user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_friends
    @friendships = current_user.friends
  end

  def search
    if params[:search_param].blank?
      flash.now[:notice] = 'Your field can not be blank!'
    elsif params[:search_param].length < 4
      flash.now[:notice] = "Word can't be lower than 4 character"
    else
      @users = User.search(params[:search_param])    
      @users = current_user.except_current_user(@users)
      flash.now[:notice] = 'You entred is not exists !' if @users.blank?              
    end    
    respond_to do |format|
      format.js { render partial: 'friends/result' }      
    end
  end

  def add_friend
    @friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: @friend.id)
    if current_user.save
      flash[:notice] = "Friend was successfully added"
    else
      flash[:notice] = "There was something wrong with the friend request"
    end
    redirect_to my_friends_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :full_name)
    end

    def require_same_user
      if current_user != @user and !current_user.admin?
        flash[:notice] = "You can only do actions your account"
        redirect_back fallback_location: root_path
      end
    end

    def require_admin
      if logged_in? and !current_user.admin?
        flash[:notice] = "You Can't do this action !"
        redirect_back fallback_location: root_path
      end
    end    

end
