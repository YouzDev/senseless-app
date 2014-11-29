class UsersController < ApplicationController

  def search
    @user = User.find_by(name: params[:q].downcase)

    render action: 'show'
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit
    @titre = "Settings"
    @user = User.find(params[:id])
  end

  def show
    @titre = "Profile"
    @user = User.find(params[:id])
  end

  def new
    @titre = "SignUp"
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to ZERZER WEBSITE!"
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

end
