class UsersController < ApplicationController
  # def index
  #   @users = User.all
  #   render :index
  # end
  # before_action :require_login, only:[:destroy]
  before_action :require_logout, only:[:new, :create]
  
  def show
    @user = User.find(params[:id])
    render :show
  end
 
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  # def edit
  #   @user = User.find(params[:id])
  #   render :edit
  # end
  # 
  # def update
  #   @user = User.find(params[:id])
  #   if @user.update_attributes(user_params)
  #     redirect_to user_url(@user)
  #   else
  #     flash.now[:errors] = @user.errors.full_messages
  #     render :edit
  #   end
  # end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
  
  
end 