# frozen_string_literal: true

# AuthHelper
module AuthHelper
  def current_user
    @current_user ||= User.find_by(uid: session[:user_id]) if session[:user_id]
  end

  def require_user
    store_location
    redirect_to signin_path, notice: 'You need to sign in!' unless logged_in?
  end

  def logged_in?
    current_user.present?
  end

  def valid_administrator?
    User.administrator?(current_user.uid) || current_user.developer?
  end

  # Determines when the currently authenticate user is allowed to Edit/Update/Destroy a given recognition
  # The recognition must belong to the current user or the current user must be an administrator
  # @param [Recognition] recognition
  def can_administrate?(recognition)
    current_user.recognitions.include?(recognition) || valid_administrator?
  end

  # Require that a current user is authenticated and an administrator
  def require_administrator
    store_location
    redirect_to signin_path, notice: 'You need to sign in!' && return unless logged_in?
    redirect_to root_url && return unless valid_administrator?
  end

  # Stores the URL trying to be accessed.
  # This allows us to redirect them back after SSO authentication
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
