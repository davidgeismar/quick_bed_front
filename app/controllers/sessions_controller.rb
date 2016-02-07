class SessionsController < ApplicationController
  before_action :check_if_already_in_session, only: [:create, :new]
  skip_before_filter :check_session

  def show
  end

  def new
  end

  def create
    @response =   HTTParty.post(ENV['API_ADDRESS']+'users/sign_in',
        :body => { :password => params[:user][:password],
                   :email => params[:user][:email]
                 }.to_json,
        :headers => { 'Content-Type' => 'application/json' } )
    unless @response["user"].blank?
      session[:user_email] = @response["user"]["email"]
      session[:user_token] = @response["user"]["authentication_token"]
      # if @response["created_account"]
      #   redirect_to account_path(@response["created_account"]["id"])
      # elsif @response["user"]["status"] == "manager"
      #   redirect_to
      unless @response["created_account"].nil?
        redirect_to account_path(@response["created_account"]["id"])
      else
        redirect_to new_account_path
      end
    else
      @errors = @response["errors"]
      render :new
    end
  end


  def destroy
    reset_session
    redirect_to login_path
  end

  private

  def check_if_already_in_session
    if session[:user_email] && session[:user_token]
      flash[:alert] = "you are already logged in"
      redirect_to new_account_path
    else
    end
  end
end
