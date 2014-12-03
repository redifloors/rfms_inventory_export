class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate

  protected

  def authenticate
    return true if session[:access]

    authenticate_or_request_with_http_basic do |name, pass|
      if name == ENV['USER_NAME'] && pass == ENV['USER_PASS']
        session[:access] = 'user'
        flash[:notice] = 'Successfully Logged in'
        return true
      end

      if name == ENV['ADMIN_NAME'] && pass == ENV['ADMIN_PASS']
        session[:access] = 'admin'
        flash[:notice] = 'Successfully Logged in as Admin'
        return true
      end

      false
    end
  end
end
