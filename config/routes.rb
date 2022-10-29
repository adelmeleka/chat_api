require 'sidekiq/web'
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :applications, only: %i[create index get update]
    end
  end

  Sidekiq::Web.use(Rack::Auth::Basic) { |user, password| [user, password] == %w[admin admin] }
  mount Sidekiq::Web => '/sidekiq'
end
