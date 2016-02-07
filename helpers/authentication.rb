module Authentication
  class GuestUser
    def method_missing(method, *args, &block)
      nil
    end

    def guest?
      true
    end
  end

  def logged_in?
    not session[:user].nil?
  end

  def current_user
    if logged_in?
      User.get session[:user]
    else
      GuestUser.new
    end
  end

  def go_back
    redirect '/' unless session[:return_to]

    return_to = session[:return_to]
    session[:return_to] = false
    redirect return_to
  end

  def restricred_area
    return true if logged_in?

    session[:return_to] = request.fullpath
    redirect '/login'
    return false
  end

  def login(username, password)
    if user = User.authenticate(username, password)
      session[:user] = user.id
      flash[:notice] = "Login successful."

      go_back
    else
      flash[:error] = "The email or password you entered is incorrect."
      redirect '/login'
    end

  end

  def logout
    session[:user] = nil
    flash[:notice] = "Logout successful."
    redirect (session[:return_to] ? session[:return_to] : '/' )
  end

end
