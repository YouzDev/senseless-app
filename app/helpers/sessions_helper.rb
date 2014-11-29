module SessionsHelper

  def signed_in?
    !current_user.nil?
  end

  def sign_in(user)
    tok = User.new_remember_token
    cookies.permanent[:remember_token] = tok
    user.update_attribute(:remember_token,
                          User.digest(tok))

    ## not necessary but in case we do not want to use redirect_to
    ## after sign_in call
    self.current_user = user
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end
 
  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

end
