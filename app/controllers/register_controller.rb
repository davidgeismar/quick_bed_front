class RegisterController < ApplicationController
  before_action :check_if_already_in_session, only: [:create, :new]
  skip_before_filter :check_session

  def new
  end

  def create
    # Post on API to create USER
    @response =   HTTParty.post(ENV['API_ADDRESS']+'users',
        :body => { :password => params[:user][:password],
                   :password_confirmation => params[:user][:password_confirmation],
                   :email => params[:user][:email]
                 }.to_json,
        :headers => { 'Content-Type' => 'application/json' })
    # si le User est bien crée je récupère son email et son token, je les store en session et je redirige vers Account#new
    if user_id = @response["id"]
      session[:user_email] = @response["email"]
      session[:user_token] = @response["authentication_token"]
      redirect_to new_account_path
    else
      puts @response
      @errors = @response["errors"]
      puts @errors
      render :new
    end
  end

  def new_password_request
  end


  def create_password_request
     # asks the API to send a change password request by email
    @response =   HTTParty.post(ENV['API_ADDRESS']+'users/password',
        :body => {
            :email => params[:user][:email],
            :app_base_url => ENV['APP_BASE_URL']
                 }.to_json,
        :headers => { 'Content-Type' => 'application/json' })
    if @response["success"]
      redirect_to create_session_path
    else
      @error = @response["error"]
      render :new_password_request
    end
  end

  def edit_password
  end

  def update_password
      @response =   HTTParty.put(ENV['API_ADDRESS']+'users/password',
        :body => {
          :password => params[:user][:password],
          :password_confirmation => params[:user][:password_confirmation],
          :reset_password_token => params[:user][:reset_password_token]
                }.to_json,
        :headers => { 'Content-Type' => 'application/json' })
    if @response["success"]
      redirect_to create_session_path
    else
      @error = @response["error"]
      render :edit_password
    end
  end

  def login
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




  # Parameters: {"user"=>{"password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "reset_password_token"=>"[FILTERED]"}, "password"=>{"user"=>{"password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "reset_password_token"=>"[FILTERED]"}}}

  #  Parameters: {"utf8"=>"✓", "authenticity_token"=>"9zMRoDaMG4brhT9cB9HHCXCPnULRy0iVrTgJhb35lmg1rcN4A74sU7Rj/DcyPcfFRn7P43z2bZ9brRLK/KxU2A==", "user"=>{"reset_password_token"=>"[FILTERED]", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"}, "commit"=>"Changer mon mot de passe"}
