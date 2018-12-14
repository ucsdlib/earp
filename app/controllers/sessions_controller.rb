# frozen_string_literal: true

# SessionsController
class SessionsController < ApplicationController
  def new
    if Rails.configuration.shibboleth
      redirect_to shibboleth_path
    else
      redirect_to developer_path
    end
  end

  def developer
    find_or_create_user('developer')
  end

  def shibboleth
    find_or_create_user('shibboleth')
  end

  def failure
    render file: Rails.root.join('public', '403'), formats: [:html], status: 403, layout: false
  end

  def find_or_create_user(auth_type)
    find_or_create_method = "find_or_create_for_#{auth_type.downcase}".to_sym
    omniauth_results = add_user_info(request)
    user = User.send(find_or_create_method, omniauth_results)

    if valid_user?(auth_type, omniauth_results)
      create_user_session(user) if user
      flash[:notice] = "You have successfully authenticated from #{auth_type} account!"
      redirect_back_or root_url
    else
      render file: Rails.root.join('public', '403'), formats: [:html], status: 403, layout: false
    end
  end

  def destroy
    destroy_user_session

    # rubocop:disable Metrics/LineLength
    redirect_to root_url,
                notice: 'You have been logged out of this applicaton. To logout of all Single Sign-On applications, close your browser'
    # rubocop:enable Metrics/LineLength
  end

  private

  def valid_user?(auth_type, omniauth_results)
    return true if auth_type.eql? 'developer'

    auth_type == 'shibboleth' && User.library_staff?(omniauth_results.uid)
  end

  def create_user_session(user)
    session[:user_name] = user.full_name
    session[:user_id] = user.uid
  end

  def destroy_user_session
    session[:user_name] = nil
    session[:user_id] = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def add_user_info(request)
    results = request.env['omniauth.auth']
    return nil unless results

    results.info[:name] = request.env['FULL_NAME']
    results.info[:email] = request.env['LONG_EMAIL']
    results
  end
end
