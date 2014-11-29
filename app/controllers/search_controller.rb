class SearchController < ApplicationController

  def search
    @user = User.find_by(name: params[:q])
    if @user.nil?
      @user = User.find_by(email: params[:q])
    end
  end

end
