class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?
  
  def login!(user)
    session[:session_token] = user.reset_session_token!
    @current_user = user
  end
  
  def logout!(user)
    if current_user
      @current_user.reset_session_token!
      session[:session_token] = nil
      @current_user = nil
    end
  end
  
  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
  
  def logged_in?
    !!current_user
  end
  
  def require_login
    redirect_to new_session_url unless logged_in?
  end
  
  def require_logout
    redirect_to cats_url if logged_in?
  end
  
  def require_owner
    redirect_to cats_url unless current_user.cats.find_by(id: params[:id])
  end

end
