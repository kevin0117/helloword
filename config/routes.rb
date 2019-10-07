Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    omniauth_callbacks: "users/omniauth_callbacks" 
  }
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources :setboxes , path: "helloword"

  resources :setboxes , path: "helloword" do
    collection do
      get '/home' ,to: 'setboxes#home'
      get '/search', to: 'setboxes#search'
      get '/pullreq', to: 'setboxes#pullreq'
      get '/write', to: 'setboxes#write'
      post '/json', to: 'setboxes#json'
    end
    member do
      post :copy
    end
    # 使用者登入首頁
  end

  # api
  namespace :api do
    namespace :v1 do
      # 你之後的路由
    end
  end

  root 'setboxes#index'
end
