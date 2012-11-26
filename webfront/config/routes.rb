MyChime::Application.routes.draw do
  root :to => 'pages#index'
  
#api
  namespace :api do
    resources :sessions, :only => [:create] do
      post :logout
    end
    resources :users, :only => [] do
      post :available
      post :call
    end
  end
end
