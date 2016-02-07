class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_session

  private

  def check_session
    if session[:user_email] && session[:user_token]
    else
      redirect_to register_path
    end
  end
end
