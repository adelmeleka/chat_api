Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :applications, only: %i[create index]
      get '/application', to: 'applications#show'
      put '/application', to: 'applications#update'
    end
  end 
  
end
