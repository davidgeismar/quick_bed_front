class RoomsController < ApplicationController

  def multiple_new
  end

  def multiple_create
    @response =   HTTParty.post(ENV['API_ADDRESS']+'api/v1/hotels/'+ params[:hotel_id]+'/rooms/multiple_create',
    :body => { :room =>{
                  :room_number => params[:room][:room_number],
                  :bed_number => params[:room][:bed_number],
                }
             }.to_json,
    :headers => { 'X-User-Email' => session[:user_email], 'X-User-Token'=> session[:user_token], 'Content-Type' => 'application/json' } )
    # Erreur Mauvais Auth Token
    if @response["error"] == "You need to sign in or sign up before continuing."
      redirect_to unauthorized_path
    # erreur de validation
    elsif @response["error"]
      raise
      @errors = @response["errors"]
      render :multiple_new
    else
      raise
      redirect_to account_path(account_id)
    end
  end
end
