Rails.application.routes.draw do


  root to: 'register#new'

   # SIGN UP ROUTES
  get "/users/sign_up", to: 'register#new', as: 'register'
  post "/users", to: 'register#create', as: 'create_user'

  # LOGIN ROUTES
  get "/users/sign_in", to: 'sessions#new', as: 'login'
  post "/users/sign_in", to: 'sessions#create', as: 'create_session'
  get "/destroy_session", to: "sessions#destroy", as:"destroy_session"
  # RESET PASSWORD ROUTES

  #PASSWORD REQUEST ROUTES
  get "/users/password/new", to: "register#new_password_request", as: "new_password_request"
  post "/users/password/new", to: "register#create_password_request", as: "create_password_request"

  #PASSWORD EDIT & UPDATE ROUTES
  get "/users/password/edit", to: "register#edit_password", as: "edit_password"
  post "users/password", to: "register#update_password", as: "update_password"

  # UNAUTHORIZED ROUTES
  get "unauthorized", to: "pages#unauthorized", as: "unauthorized"
  # NOT FOUND
  get "not_found", to: "pages#not_found", as: "not_found"


  resources :slots, only: [ :index, :show, :update, :create ]
    resources :rooms, only: [ :index, :show, :update, :create ]
    resources :beds, only: [ :index, :show, :update, :create ]
    resources :accounts, only: [ :new, :edit, :index, :show, :update, :create ] do
      resources :hotels, only: [ :new, :edit, :index, :show, :update, :create ]
    end

  resources :hotels, only: [:show] do
    get '/rooms/multiple_new', to: 'rooms#multiple_new', as: "room_multiple_new"
    post '/rooms/multiple_create', to: 'rooms#multiple_create', as: "room_multiple_create"
  end
end
