class MicropostsController < ApplicationController

  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Message posted!"
      redirect_to root_url
    else
      render 'pages/home'
    end
  end

  def destroy
  end

  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
