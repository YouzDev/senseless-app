module SessionsHelper

  def signed_in?
    !current_user.nil?
  end

  def sign_in(user)
    session[:user_id] = user.id
    # tok = User.new_remember_token
    # cookies.permanent[:remember_token] = tok
    # user.update_attribute(:remember_token,
    #                       User.digest(tok))
    ## not necessary but in case we do not want to use redirect_to
    ## after sign_in call
    # self.current_user = user
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def sign_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
    
    # current_user.update_attribute(:remember_token,
    #                               User.digest(User.new_remember_token))
    # cookies.delete(:remember_token)
    # self.current_user = nil
  end
 
  # def current_user=(user)
  #   @current_user = user
  # end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        sign_in user
        @current_user = user
      end
    end
    # remember_token = User.digest(cookies[:remember_token])
    # @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
  
end
