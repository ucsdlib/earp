# frozen_string_literal: true

# AuthHelper
module AuthHelper
  def current_user
    @current_user ||= User.find_by(uid: session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to signin_path, notice: 'You need to sign in!' unless logged_in?
  end

  def logged_in?
    current_user.present?
  end
end
