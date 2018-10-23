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
    redirect_to root_url, alert: 'You are not an authorized Library employee'
  end

  def find_or_create_user(auth_type)
    find_or_create_method = "find_or_create_for_#{auth_type.downcase}".to_sym
    omniauth_results = request.env['omniauth.auth']
    @user = User.send(find_or_create_method, omniauth_results)

    if valid_user?(auth_type, omniauth_results)
      create_user_session(@user) if @user
      redirect_to root_url, notice: "You have successfully authenticated from #{auth_type} account!"
    else
      render file: Rails.root.join('public', '403'), formats: [:html], status: 403, layout: false
    end
  end

  def destroy
    destroy_user_session
    if Rails.configuration.shibboleth
      # rubocop:disable Metrics/LineLength,Rails/OutputSafety
      flash[:alert] = 'You have been logged out of this applicaton. To logout of all Single Sign-On applications, close your browser'.html_safe
      # rubocop:enable Metrics/LineLength,Rails/OutputSafety
    end

    redirect_to root_url
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
end
