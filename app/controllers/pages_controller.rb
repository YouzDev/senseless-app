class PagesController < ApplicationController
  def home
    @titre = "Home"
    @micropost = current_user.microposts.build if signed_in?
  end

  def contact
    @titre = "Contact"
  end

  def about
    @titre = "About"
  end

  def help
    @titre = "Help"
  end

  def signin
    @titre = "Sign in"
  end

  def search
    @titre = "Search"
  end

end
