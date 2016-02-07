class HotelsController < ApplicationController
  def new
     @hotel = Hotel.new
  end

  def show
      @response =   HTTParty.get(ENV['API_ADDRESS'] +"api/v1/hotels/"+params[:id],
    :headers => { 'X-User-Email' => session[:user_email], 'X-User-Token'=> session[:user_token], 'Content-Type' => 'application/json' }
      )
    if @response.message == "Unauthorized"
      redirect_to unauthorized_path
    elsif  @response.message == "Not Found"
      redirect_to not_found_path
    else
      @hotel = @response["hotel"]
    end
  end

  def index
    @response =   HTTParty.get(ENV['API_ADDRESS'] +"api/v1/accounts/"+params[:account_id]+"/hotels",
    :headers => { 'X-User-Email' => session[:user_email], 'X-User-Token'=> session[:user_token], 'Content-Type' => 'application/json' }
      )

    if @response["hotels"].blank?
      flash[:notice] = "You have not created any hotels yet !"
      redirect_to account_path(params[:account_id])
    else
      @hotels =  @response["hotels"]
    end
  end

  def create
    @hotel = Hotel.new(params[:hotel])
    if @hotel.valid?
      # Post API sur create hotel
      @result =   HTTParty.post(ENV['API_ADDRESS']+'api/v1/accounts/'+params[:account_id]+'/hotels',
          :body => { :name=> params[:hotel][:name],
                     :contact_mail => params[:hotel][:contact_mail],
                     :contact_phone => params[:hotel][:contact_phone],
                     :address => params[:hotel][:address],
                     :city => params[:hotel][:city],
                     :postcode => params[:hotel][:postcode]
                   }.to_json,
          :headers => { 'X-User-Email' => session[:user_email], 'X-User-Token'=> session[:user_token], 'Content-Type' => 'application/json' })

      # erreur bad auth token
      if @result["error"] == "You need to sign in or sign up before continuing."
        redirect_to unauthorized_path
      # erreur de valid
      elsif @result["errors"]
        @errors = @result["errors"]
        render :new
      # redir sur hotel#show
      else
        hotel_id = @result["hotel"]["id"]
        redirect_to account_hotel_path(params[:account_id], hotel_id)
      end
    else
      render :new
    end
  end

end
