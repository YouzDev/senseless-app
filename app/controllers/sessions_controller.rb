class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:login].downcase)
    if !user
      user = User.find_by(name: params[:session][:login].downcase)
    end

    if user && user.authenticate(params[:session][:password])
      sign_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
      # redirect_to user
    else
      flash.now[:error] = 'Invalid login and/or password'
      render 'new'
    end
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_url
  end

end
