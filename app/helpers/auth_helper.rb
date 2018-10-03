# frozen_string_literal: true

# AuthHelper
module AuthHelper
  # TODO: sort out what's needed here..
  def current_user
    @current_user ||= User.find_by(uid: session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to signin_path, notice: 'You need to sign in!' unless logged_in?
  end

  def logged_in?
    current_user.present?
  end

  def authorize
    # TODO: can this be: logged_in? || access_denied
    logged_in? ? true : access_denied
  end

  def access_denied
    flash[:alert] = 'You must sign in to perform this action.'
    redirect_to new_user_session_path(origin: request.original_url) and return false
  end
end
