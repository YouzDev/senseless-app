class PagesController < ApplicationController
  def home
    @titre = "Home"
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
