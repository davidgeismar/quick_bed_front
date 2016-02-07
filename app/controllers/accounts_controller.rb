class AccountsController < ApplicationController
  before_action :authorized?, only: :new

  def show
    @response =   HTTParty.get(ENV['API_ADDRESS'] +"api/v1/accounts/"+params[:id],
  :headers => { 'X-User-Email' => session[:user_email], 'X-User-Token'=> session[:user_token], 'Content-Type' => 'application/json' }
    )
    if @response.message == "Unauthorized"
      redirect_to unauthorized_path
    elsif  @response.message == "Not Found"
      redirect_to not_found_path
    else
      @account = @resp["account"]
    end
  end

  def create
    @account = Account.new(params[:account])
    if @account.valid?
      # Post sur API create Account
       @response =   HTTParty.post(ENV['API_ADDRESS']+'api/v1/accounts',
        :body => { :name => params[:account][:name],
                   :contact_mail => params[:account][:contact_mail],
                   :contact_tel =>  params[:account][:contact_tel],
                   :legal_status => params[:account][:legal_status],
                   :iban => params[:account][:iban],
                   :bic => params[:account][:bic]
                 }.to_json,
        :headers => { 'X-User-Email' => session[:user_email], 'X-User-Token'=> session[:user_token], 'Content-Type' => 'application/json' } )
        # Erreur Mauvais Auth Token
        if @response["error"] == "You need to sign in or sign up before continuing."
          flash[:notice] = "Please Sign Up or Sign In to access this page"
          redirect_to login_path
        # Erreur de validation
        elsif @response["errors"]
          @errors = @response["errors"]
          render :new
        else
          account_id = @response["account"]["id"]
          redirect_to account_path(account_id)
        end
    else
      render :new
    end
  end

  def new
    @account = Account.new
  end

  private

  # User can be admin of only one account so if he already possesses an account he should not be allowed to access the new page
  def authorized?
    @response = HTTParty.post(ENV['API_ADDRESS']+'api/v1/check_account',
        :body => {}.to_json,
        :headers => { 'X-User-Email' => session[:user_email], 'X-User-Token'=> session[:user_token], 'Content-Type' => 'application/json' })
    if  account_id = @response["account"]
      flash[:notice] = "You already have an account"
      redirect_to account_path(account_id)
    else
    end
  end
end

